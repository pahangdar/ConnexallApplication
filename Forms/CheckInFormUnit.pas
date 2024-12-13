unit CheckInFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, System.Generics.Collections,
  Vcl.Grids, AppointmentUnit;

type
  TCheckInForm = class(TForm)
    Button1: TButton;
    PanelOptions: TPanel;
    DateTimePicker: TDateTimePicker;
    Label1: TLabel;
    PageControlAppointments: TPageControl;
    TabPending: TTabSheet;
    TabConfirming: TTabSheet;
    TabConfirmed: TTabSheet;
    TabNotConfirmed: TTabSheet;
    TabCancelled: TTabSheet;
    TabCanceld: TTabSheet;
    StringGridPending: TStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DateTimePickerChange(Sender: TObject);
    procedure PopulateGrids(Appointments: TObjectList<TAppointment>);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CheckInForm: TCheckInForm;

implementation

{$R *.dfm}

uses PatientUnit, DoctorUnit, MainFormUnit, AppointmentsDataAccessUnit, AppointmentsUtils;

procedure TCheckInForm.PopulateGrids(Appointments: TObjectList<TAppointment>);
var
  Appointment: TAppointment;
  RowIndex: Integer;

  procedure AddToGrid(Grid: TStringGrid; Appointment: TAppointment);
  begin
    RowIndex := Grid.RowCount ;
    Grid.RowCount := RowIndex + 1;
    Grid.Cells[0, RowIndex] := IntToStr(RowIndex);
    Grid.Cells[1, RowIndex] := FormatDateTime('hh:nn', Appointment.Time);
    Grid.Cells[2, RowIndex] := Appointment.Patient.GetFullName;
    Grid.Cells[3, RowIndex] := Appointment.Doctor.GetFullName;
    Grid.Cells[4, RowIndex] := AppointmentStatusToString(Appointment.Status); // Show status
  end;

begin
  // Clear all grids before populating
  self.StringGridPending.RowCount := 1;
//  TabConfirmingGrid.RowCount := 1;
//  TabConfirmedGrid.RowCount := 1;
//  TabNotConfirmedGrid.RowCount := 1;
//  TabCancelledGrid.RowCount := 1;
//  TabCompletedGrid.RowCount := 1;

  for Appointment in Appointments do
  begin
//    AddToGrid(self.StringGridPending, Appointment);
    case Appointment.Status of
      Pending: AddToGrid(self.StringGridPending, Appointment);
//      Confirming: AddToGrid(TabConfirmingGrid, Appointment);
//      Confirmed: AddToGrid(TabConfirmedGrid, Appointment);
//      NotConfirmed: AddToGrid(TabNotConfirmedGrid, Appointment);
//      Cancelled: AddToGrid(TabCancelledGrid, Appointment);
//      Completed: AddToGrid(TabCompletedGrid, Appointment);
    end;
  end;

  self.StringGridPending.FixedRows := 1;
end;


procedure TCheckInForm.DateTimePickerChange(Sender: TObject);
var
  Appointments: TObjectList<TAppointment>;
begin
  Appointments := TAppointmentsDataAccess.GetAppointmentsByDate(DateTimePicker.Date);
  try
    PopulateGrids(Appointments);
  finally
    Appointments.Free;
  end;end;

procedure TCheckInForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  CheckInForm := nil;
  MainForm.ToolButtonCheckIn.Enabled := true;
end;

procedure TCheckInForm.FormCreate(Sender: TObject);
begin
  self.StringGridPending.ColCount := 5;
  self.StringGridPending.Cells[0, 0] := 'Seq#';
  self.StringGridPending.Cells[1, 0] := 'Time';
  self.StringGridPending.Cells[2, 0] := 'Patient Name';
  self.StringGridPending.Cells[3, 0] := 'Doctor Name';
  self.StringGridPending.Cells[4, 0] := 'Status';
end;

procedure TCheckInForm.FormShow(Sender: TObject);
begin
  MainForm.ToolButtonCheckIn.Enabled := false;
end;

procedure TCheckInForm.Button1Click(Sender: TObject);
var newPatient: TPatient;
    newDoctor: TDoctor;
    newAppointment: TAppointment;
begin

  newPatient := TPatient.Create(101,'Saeid', 'Pahangdar', '438-368-8456', '9960 Bayview Ave.', EncodeDate(1971, 5, 1), 'pahangdar@gmail.com' );
  try
    ShowMessage('Patient: ' + newPatient.GetFullName);
  finally
//    newPatient.Free;
//    ShowMessage('Free Patient');
  end;

  try
    newDoctor := TDoctor.Create(201, 'Mike', 'Cedar', '', '', '');
    try
      ShowMessage('Doctro: ' + newDoctor.GetFullName)
    finally
//      newDoctor.Free;
//      ShowMessage('Free Doctor')
    end;
  except on E : Exception do
    ShowMessage('Error ' + E.Message)
  end;

  try
    newAppointment := Tappointment.Create(301, EncodeDate(2024, 12, 13), EncodeTime(11, 30, 0, 0), newPatient, newDoctor, Pending);
    try
      ShowMessage('Appointment: Patient> ' + newAppointment.Patient.GetFullName + ' < with Doctor> ' + newAppointment.Doctor.GetFullName + ' <')
    finally
      newAppointment.Free;
      Showmessage('Appointment Free');
      newPatient.Free;
      ShowMessage('Free Patient');
      newDoctor.Free;
      ShowMessage('Free Doctor')
    end;
  except

  end;
end;

end.
