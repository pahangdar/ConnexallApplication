unit AppointmentTabUnit;

interface

uses
  VCL.ComCtrls, DBGridEh, Datasnap.DBClient, Vcl.Dialogs, System.SysUtils, Vcl.Controls,
  DBGridEh.DBUtils, Vcl.Menus, System.Types,
  AppointmentUnit;

type
  TFilterProcedure = reference to function(const Status: string): Integer;

  TAppointmentTab = class
    private
      FStatus: TAppointmentStatus;
      FTabSheet: TTabSheet;
      FDBGridEh: TDBGridEh;
      FPopupMenu: TPopupMenu;
      FTitle: string;
      FRecordCount: Integer;
      FFilterProcedure: TFilterProcedure;
      procedure TabSheetShowHandler(Sender: TObject);
      procedure DbGridDbClick(Sender: TObject);
      procedure SetRecordCount(const Value: Integer);
      procedure UpdateTabSheetCaption;
      procedure SetDBGridOptions;
      procedure UpdateMenuItems;
    public
      constructor Create(
        AStatus: TAppointmentStatus;
        AOwner: TPageControl;
        ATitle: string;
        ADataSource: TClientDataSet;
        AFilterProcedure: TFilterProcedure;
        APopupMenu: TPopupMenu;
        ARecordCount: Integer = 0
      );
      property TabSheet: TTabSheet read FTabSheet write FTabSheet;
      property DBGridEh: TDBGridEh read FDBGridEh write FDBGridEh;
      property Title: string read FTitle write FTitle;
      property RecordCount: Integer read FRecordCount write SetRecordCount;
      property Status: TAppointmentStatus read FStatus write FStatus;
      property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
      procedure DecrementRecordCount;
      procedure IncrementRecordCount;
  end;

implementation

constructor TAppointmentTab.Create(
    AStatus: TAppointmentStatus;
    AOwner: TPageControl;
    ATitle: string;
    ADataSource: TClientDataSet;
    AFilterProcedure: TFilterProcedure;
    APopupMenu: TPopupMenu;
    ARecordCount: Integer = 0
  );
begin
  if not Assigned(AOwner) then
    raise Exception.Create('AOwner is not assigned.');
  if not Assigned(ADataSource) then
    raise Exception.Create('ADataSource is not assigned.');

  if not Assigned(ADataSource) then
    raise Exception.Create('ADataSource.DataSet is not assigned.');

  FStatus := AStatus;
  FTitle := ATitle;
  FRecordCount := ARecordCount;
  FFilterProcedure := AFilterProcedure;
  FPopupMenu := APopupMenu;

  FTabSheet := TTabSheet.Create(AOwner);
  FTabSheet.PageControl := AOwner;
  UpdateTabSheetCaption;
  FTabSheet.OnShow := TabSheetShowHandler;

  FDBGridEh := TDBGridEh.Create(FTabSheet);
  FDBGridEh.Parent := FTabSheet;
  FDBGridEh.DataSource := ADataSource;
  FDBGridEh.PopupMenu := APopupMenu;
  FDBGridEh.OnDblClick := DbGridDbClick;
  SetDBGridOptions;
end;

procedure TAppointmentTab.SetDBGridOptions;
const
  ColumnDefinitions: array[0..7] of record
    FieldName: string;
    Width: Integer;
    TitleCaption: string;
  end = (
    (FieldName: 'Time'; Width: 70; TitleCaption: ''),
    (FieldName: 'PatientName'; Width: 150; TitleCaption: ''),
    (FieldName: 'DoctorName'; Width: 100; TitleCaption: ''),
    (FieldName: 'Status'; Width: 60; TitleCaption: ''),
    (FieldName: 'PhoneNumber'; Width: 100; TitleCaption: ''),
    (FieldName: 'Address'; Width: 150; TitleCaption: ''),
    (FieldName: 'AppointmentID'; Width: 60; TitleCaption: ''),
    (FieldName: 'VerificationResult'; Width: 120; TitleCaption: 'Verification Result')
  );
var
  i: Integer;
begin
  FDBGridEh.Align := alClient;
  FDBGridEh.Options := FDBGridEh.Options + [dgRowSelect] + [dgAlwaysShowSelection];
  FDBGridEh.OptionsEh := FDBGridEh.OptionsEh + [dghShowRecNo];
  FDBGridEh.SearchPanel.Enabled := true;

  for i := Low(ColumnDefinitions) to High(ColumnDefinitions) do
    with FDBGridEh.Columns.Add do
    begin
      FieldName := ColumnDefinitions[i].FieldName;
      Width := ColumnDefinitions[i].Width;
      if ColumnDefinitions[i].TitleCaption <> '' then
        Title.Caption := ColumnDefinitions[i].TitleCaption
    end;
end;

procedure TAppointmentTab.TabSheetShowHandler(Sender: TObject);
begin
  UpdateMenuItems;

  if Assigned(FFilterProcedure) then
  begin
//    ShowMessage('Filtering ' + FTitle);
    FRecordCount := FFilterProcedure(FTitle);
  end
  else
  begin
    FRecordCount := 0;
//    ShowMessage('No Filtering ');
  end;
  UpdateTabSheetCaption;
end;

procedure TAppointmentTab.DbGridDbClick(Sender: TObject);
var
  MousePosition: TPoint;
begin
  MousePosition := Mouse.CursorPos;
  FPopupMenu.Popup(MousePosition.X, MousePosition.Y);
end;

procedure TAppointmentTab.SetRecordCount(const Value: Integer);
begin
  if FRecordCount = Value then
    exit;

  FRecordCount := Value;
  UpdateTabSheetCaption;
end;

procedure TAppointmentTab.DecrementRecordCount;
begin
  if FRecordCount = 0 then
    exit;
  Dec(FRecordCount);
  UpdateTabSheetCaption;
end;

procedure TAppointmentTab.IncrementRecordCount;
begin
   Inc(FRecordCount);
   UpdateTabSheetCaption;
end;

procedure TAppointmentTab.UpdateMenuItems;
var
  MenuItem: TMenuItem;
  StatusPrefix: string;
begin
  if not Assigned(FPopupMenu) then
    exit;

  for MenuItem in FPopupMenu.Items do
    MenuItem.Enabled := false;

  case FStatus of
    Pending: StatusPrefix := 'miPending';
    Confirming: StatusPrefix := 'miConfirming';
    Confirmed: StatusPrefix := 'miConfirmed';
    NotConfirmed: StatusPrefix := 'miNotConfirmed';
    Cancelled: StatusPrefix := 'miCancelled';
    Completed: StatusPrefix := 'miCompleted';
  else
    Exit;
  end;

  for MenuItem in FPopupMenu.Items do
  begin
    if Pos(StatusPrefix, MenuItem.Name) = 1 then
      MenuItem.Enabled := True;
  end;
end;

procedure TAppointmentTab.UpdateTabSheetCaption;
begin
  FTabSheet.Caption := FTitle + '(' + FRecordCount.ToString + ')';
end;

end.
