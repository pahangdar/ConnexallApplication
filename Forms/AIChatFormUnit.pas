unit AIChatFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL,
  GridsEh, DBAxisGridsEh, DBGridEh, REST.Client, REST.Types, System.JSON,
  Vcl.ComCtrls, Vcl.Grids, System.Generics.Collections,
  System.Net.HttpClient, System.Net.URLClient, System.Net.HttpClientComponent;

type
  TAIChatForm = class(TForm)
    PanelChat: TPanel;
    PanelButton: TPanel;
    MemoInput: TMemo;
    BtnAskAI: TBitBtn;
    PageControlResults: TPageControl;
    TabSheetChat: TTabSheet;
    TabSheetSQL: TTabSheet;
    TabSheetResult: TTabSheet;
    MemoSQL: TMemo;
    MemoChat: TMemo;
    StringGridResults: TStringGrid;
    procedure BtnAskAIClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure SetFormSize;
  private
    function GenerateSQL(const Query: string): string;
    function ExecuteSql(const SQL: string): string;
    function GenerateResponse(const Query, SQL, SQLResults: string): string;
    procedure UpdateChatHistory(const Query, Response: string);
    procedure UpdateSQLTab(const SQL: string);
  public
    { Public declarations }
  end;

var
  AIChatForm: TAIChatForm;

implementation
uses
  REST.Json, Data.DBXJSON, MainFormUnit;

{$R *.dfm}

procedure TAIChatForm.BtnAskAIClick(Sender: TObject);
var
  Query, SQL, SQLResults, ResultsJSON, AIResponse: string;
begin
  Query := MemoInput.Text;
  if Query.Trim = '' then Exit;

  // Step 1: Call generate-sql
  SQL := GenerateSQL(Query);
  UpdateSQLTab(SQL);

  // Step 2: Call execute-sql
  ResultsJSON := ExecuteSql(SQL);

  // Step 3: Call generate-response
  AIResponse := GenerateResponse(Query, SQL, ResultsJSON);
  UpdateChatHistory(Query, AIResponse);

  MemoInput.Clear;
end;

function TAIChatForm.GenerateSQL(const Query: string): string;
var
  HTTPClient: THTTPClient;
  Response: IHTTPResponse;
  JSONRequest, JSONResponse: TJSONObject;
  Content: TStringStream;
  URL: string;
begin
  Result := '';
  URL := Format('%s/%s', ['http://localhost:5000', 'generate-sql']);
  HTTPClient := THTTPClient.Create;

  JSONRequest := TJSONObject.Create;
  JSONRequest.AddPair('query', Query);
  Content := TStringStream.Create(JSONRequest.ToString, TEncoding.UTF8);  // Convert JSON to Stream

  try
    HTTPClient.ContentType := 'application/json';
    Response := HTTPClient.Post(URL, Content);

    if Response.StatusCode = 200 then
    begin
      JSONResponse := TJSONObject.ParseJSONValue(Response.ContentAsString(TEncoding.UTF8)) as TJSONObject;
      if Assigned(JSONResponse) then
      begin
        Result := JSONResponse.GetValue<string>('sql_query');
        JSONResponse.Free;
      end;
    end
    else
      raise Exception.CreateFmt('HTTP Error %d: %s', [Response.StatusCode, Response.StatusText]);
  finally
    Content.Free;
    HTTPClient.Free;
  end;
end;

function TAIChatForm.ExecuteSQL(const SQL: string): string;
var
  HTTPClient: THTTPClient;
  Response: IHTTPResponse;
  JSONRequest, JSONResponse: TJSONObject;
  JSONArray: TJSONArray;
  RowObj: TJSONObject;
  Keys: TStringList;
  Row, Col: Integer;
  URL: string;
  Content: TStringStream;
begin
  Result := '';
  URL := Format('%s/%s', ['http://localhost:5000', 'execute-sql']);
  HTTPClient := THTTPClient.Create;
  JSONRequest := TJSONObject.Create;
  JSONRequest.AddPair('sql_query', SQL);
  Content := TStringStream.Create(JSONRequest.ToString, TEncoding.UTF8);
  Keys := TStringList.Create;
  StringGridResults.RowCount := 0;
  StringGridResults.ColCount := 0;
  StringGridResults.FixedRows := 0;
  StringGridResults.FixedCols := 0;

  try
    HTTPClient.ContentType := 'application/json';
    Response := HTTPClient.Post(URL, Content);

    if Response.StatusCode = 200 then
    begin
      JSONResponse := TJSONObject.ParseJSONValue(Response.ContentAsString(TEncoding.UTF8)) as TJSONObject;
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

      JSONResponse.Free;
    end
//    else
//      raise Exception.CreateFmt('HTTP Error %d: %s', [Response.StatusCode, Response.StatusText]);

  finally
    JSONRequest.Free;
    Content.Free;
    HTTPClient.Free;
    Keys.Free;
  end;
end;

function TAIChatForm.GenerateResponse(const Query, SQL,
  SQLResults: string): string;
var
  HTTPClient: THTTPClient;
  Response: IHTTPResponse;
  JSONRequest, JSONResponse: TJSONObject;
  Content: TStringStream;
  URL: string;
begin
  Result := '';
  URL := Format('%s/%s', ['http://localhost:5000', 'generate-response']);
  HTTPClient := THTTPClient.Create;

  JSONRequest := TJSONObject.Create;
  JSONRequest.AddPair('query', Query);
  JSONRequest.AddPair('sql_query', SQL);
  JSONRequest.AddPair('results', SQLResults);
  Content := TStringStream.Create(JSONRequest.ToString, TEncoding.UTF8);  // Convert JSON to Stream

  try
    HTTPClient.ContentType := 'application/json';
    Response := HTTPClient.Post(URL, Content);

    if Response.StatusCode = 200 then
    begin
      JSONResponse := TJSONObject.ParseJSONValue(Response.ContentAsString(TEncoding.UTF8)) as TJSONObject;
      if Assigned(JSONResponse) then
      begin
        Result := JSONResponse.GetValue<string>('natural_response');
        JSONResponse.Free;
      end;
    end
    else
      raise Exception.CreateFmt('HTTP Error %d: %s', [Response.StatusCode, Response.StatusText]);
  finally
    Content.Free;
    HTTPClient.Free;
  end;
end;

procedure TAIChatForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  AIChatForm := nil;
  MainForm.ToolButtonAIChat.Enabled := true;
end;

procedure TAIChatForm.FormShow(Sender: TObject);
begin
  MainForm.ToolButtonAIChat.Enabled := false;
  self.PageControlResults.ActivePageIndex := 0;
end;

procedure TAIChatForm.UpdateChatHistory(const Query, Response: string);
begin
  MemoChat.Lines.Add('User: ' + Query);
  MemoChat.Lines.Add('AI: ' + Response);
  MemoChat.Lines.Add('-----------------------------');
end;

procedure TAIChatForm.UpdateSQLTab(const SQL: string);
begin
  MemoSQL.Text := SQL;
end;

procedure TAIChatForm.SetFormSize;
begin
  AIChatForm.Width := 700;
  AIChatForm.Height := MainForm.Height - 200;
  AIChatForm.Top := 0;
  AIChatForm.Left := MainForm.Width - AIChatForm.Width - 20;
end;

end.
