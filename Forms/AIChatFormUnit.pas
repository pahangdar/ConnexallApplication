unit AIChatFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL,
  GridsEh, DBAxisGridsEh, DBGridEh, REST.Client, REST.Types, System.JSON,
  Vcl.ComCtrls, Vcl.Grids, System.Generics.Collections,
  System.Net.HttpClient, System.Net.URLClient, System.Net.HttpClientComponent,
  UIFormResizable;

type
  TAIChatForm = class(TForm, IResizableForm)
    PanelChat: TPanel;
    PanelButton: TPanel;
    MemoInput: TMemo;
    BtnAskAI: TBitBtn;
    PageControlResults: TPageControl;
    TabSheetChat: TTabSheet;
    TabSheetSQL: TTabSheet;
    TabSheetResult: TTabSheet;
    MemoSQL: TMemo;
    StringGridResults: TStringGrid;
    ScrollBoxChat: TScrollBox;
    procedure BtnAskAIClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure SetFormSize;
  private
    function GenerateSQL(const Query: string): string;
    function ExecuteSql(const SQL: string): string;
    function GenerateResponse(const Query, SQL, SQLResults: string): string;
    procedure UpdateSQLTab(const SQL: string);
    procedure AddChatMessage(const MsgText: string; IsUser: Boolean);
    function PostJSON(const URL: string; const RequestJSON: TJSONObject): TJSONObject;
  public
    { Public declarations }
  end;

var
  AIChatForm: TForm;

implementation
uses
  REST.Json, Data.DBXJSON, MainFormUnit, ChatBubbleFrameUnit;

{$R *.dfm}

procedure TAIChatForm.AddChatMessage(const MsgText: string; IsUser: Boolean);
var
  ChatBubble: TChatBubbleFrame;
  BubbleMaxWidth, LeftPos: Integer;
begin
  // Max width for the bubble
  BubbleMaxWidth := ScrollBoxChat.ClientWidth - 20;

  ChatBubble := TChatBubbleFrame.Create(Self);
  ChatBubble.Parent := ScrollBoxChat;
  ChatBubble.Name := ''; // Avoid duplicate error
  ChatBubble.Align := alTop;
  ChatBubble.AutoSize := True;
  ChatBubble.Width := BubbleMaxWidth;

  ChatBubble.PanelBubble.AutoSize := false;
  ChatBubble.LabelMessage.AutoSize := false;


  with ChatBubble.PanelBubble do
  begin
//    Color := IfThen(IsUser, clSkyBlue, clWhite);
//    BorderRadius := 20;
    Constraints.MaxWidth := BubbleMaxWidth;

    Anchors := [akLeft, akTop];
  end;

  with ChatBubble.LabelMessage do
  begin
    Caption := MsgText;
    WordWrap := True;
    Width := BubbleMaxWidth - 200;
  end;

  ChatBubble.LabelMessage.AutoSize := true;
  ChatBubble.PanelBubble.AutoSize := true;

  if IsUser then
  begin
    ChatBubble.PanelBubble.Left := ChatBubble.Width - ChatBubble.PanelBubble.Width - 15;
    ChatBubble.ShapeBorder.Brush.Color := clSkyBlue;
  end
  else
  begin
    ChatBubble.PanelBubble.Left := 10;
    ChatBubble.ShapeBorder.Brush.Color := clWhite;
  end;

//  ChatBubble.Visible := True;
//  Scroll to bottom
  ScrollBoxChat.VertScrollBar.Position := ScrollBoxChat.VertScrollBar.Range;
end;

procedure TAIChatForm.BtnAskAIClick(Sender: TObject);
var
  Query, SQL, SQLResults, ResultsJSON, AIResponse: string;
begin
  Query := MemoInput.Text;
  if Query.Trim = '' then Exit;

  AddChatMessage(Query, true);

  // Step 1: Call generate-sql
  SQL := GenerateSQL(Query);
  UpdateSQLTab(SQL);

  // Step 2: Call execute-sql
  ResultsJSON := ExecuteSql(SQL);

  // Step 3: Call generate-response
  AIResponse := GenerateResponse(Query, SQL, ResultsJSON);
  AddChatMessage(AIResponse, false);

  MemoInput.Clear;
end;

function TAIChatForm.PostJSON(const URL: string; const RequestJSON: TJSONObject): TJSONObject;
var
  HTTPClient: THTTPClient;
  Content: TStringStream;
  Response: IHTTPResponse;
begin
  Result := nil;
  HTTPClient := THTTPClient.Create;
  Content := TStringStream.Create(RequestJSON.ToString, TEncoding.UTF8);
  try
    HTTPClient.ContentType := 'application/json';
    Response := HTTPClient.Post(URL, Content);

    if Response.StatusCode = 200 then
      Result := TJSONObject.ParseJSONValue(Response.ContentAsString(TEncoding.UTF8)) as TJSONObject
    else
      raise Exception.CreateFmt('HTTP Error %d: %s', [Response.StatusCode, Response.StatusText]);

  finally
    Content.Free;
    HTTPClient.Free;
  end;
end;

function TAIChatForm.GenerateSQL(const Query: string): string;
var
  JSONRequest, JSONResponse: TJSONObject;
  URL: string;
begin
  Result := '';
  URL := Format('%s/%s', ['http://localhost:5000', 'generate-sql']);

  JSONRequest := TJSONObject.Create;
  try
    JSONRequest.AddPair('query', Query);
    try
      JSONResponse := PostJSON(URL, JSONRequest);
      try
        if Assigned(JSONResponse) then
          Result := JSONResponse.GetValue<string>('sql_query');
      finally
        JSONResponse.Free;
      end;
    except
      on E: Exception do
        raise Exception.CreateFmt('GenerateSQL failed: %s', [E.Message]);
    end;
  finally
    JSONRequest.Free;
  end;
end;

function TAIChatForm.ExecuteSQL(const SQL: string): string;
var
  JSONRequest, JSONResponse: TJSONObject;
  JSONArray: TJSONArray;
  RowObj: TJSONObject;
  Keys: TStringList;
  Row, Col: Integer;
begin
  Result := '';
  JSONRequest := TJSONObject.Create;
  Keys := TStringList.Create;
  StringGridResults.RowCount := 0;
  StringGridResults.ColCount := 0;
  StringGridResults.FixedRows := 0;
  StringGridResults.FixedCols := 0;

  try
    JSONRequest.AddPair('sql_query', SQL);
    try
      JSONResponse := PostJSON('http://localhost:5000/execute-sql', JSONRequest);
      try
        if not Assigned(JSONResponse) then
          Exit;

        JSONArray := JSONResponse.GetValue<TJSONArray>('results');
        if (JSONArray <> nil) and (JSONArray.Count > 0) then
        begin
          Result := JSONArray.ToJSON;

          // Extract column names from first row
          RowObj := JSONArray.Items[0] as TJSONObject;
          Keys.Clear;
          for Col := 0 to RowObj.Count - 1 do
            Keys.Add(RowObj.Pairs[Col].JsonString.Value);

          // Prepare StringGrid
          StringGridResults.RowCount := JSONArray.Count + 1;
          StringGridResults.ColCount := Keys.Count;
          StringGridResults.FixedRows := 1;

          // Set column headers
          for Col := 0 to Keys.Count - 1 do
            StringGridResults.Cells[Col, 0] := Keys[Col];

          // Fill grid with data
          for Row := 0 to JSONArray.Count - 1 do
          begin
            RowObj := JSONArray.Items[Row] as TJSONObject;
            for Col := 0 to Keys.Count - 1 do
              StringGridResults.Cells[Col, Row + 1] := RowObj.GetValue<string>(Keys[Col]);
          end;
        end;

      finally
        JSONResponse.Free;
      end;
    except
      on E: Exception do
        raise Exception.CreateFmt('ExecuteSQL failed: %s', [E.Message]);
    end;
  finally
    JSONRequest.Free;
    Keys.Free;
  end;
end;

function TAIChatForm.GenerateResponse(const Query, SQL, SQLResults: string): string;
var
  JSONRequest, JSONResponse: TJSONObject;
begin
  Result := '';
  JSONRequest := TJSONObject.Create;
  try
    JSONRequest.AddPair('query', Query);
    JSONRequest.AddPair('sql_query', SQL);
    JSONRequest.AddPair('results', SQLResults);

    try
      JSONResponse := PostJSON('http://localhost:5000/generate-response', JSONRequest);
      try
        if Assigned(JSONResponse) then
          Result := JSONResponse.GetValue<string>('natural_response')
        else
          raise Exception.Create('No response received from the server.');
      finally
        JSONResponse.Free;
      end;
    except
      on E: Exception do
        raise Exception.CreateFmt('GenerateResponse failed: %s', [E.Message]);
    end;

  finally
    JSONRequest.Free;
  end;
end;

procedure TAIChatForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  AIChatForm := nil;
  if Assigned(MainForm) then
    MainForm.ToolButtonAIChat.Enabled := true;
end;

procedure TAIChatForm.FormShow(Sender: TObject);
begin
  MainForm.ToolButtonAIChat.Enabled := false;
  self.PageControlResults.ActivePageIndex := 0;
end;

procedure TAIChatForm.UpdateSQLTab(const SQL: string);
begin
  MemoSQL.Text := SQL;
end;

procedure TAIChatForm.SetFormSize;
begin
  Self.Width := 700;
  Self.Height := MainForm.Height - 200;
  Self.Top := 0;
  Self.Left := MainForm.Width - Self.Width - 20;
end;

end.
