unit CheckInFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TCheckInForm = class(TForm)
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CheckInForm: TCheckInForm;

implementation

{$R *.dfm}

uses PatientUnit, DoctorUnit, AppointmentUnit, MainFormUnit;

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
    newDoctor := TDoctor.Create(201, 'Mike', 'Cedar');
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

procedure TCheckInForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  CheckInForm := nil;
  MainForm.ToolButtonCheckIn.Enabled := true;
end;

procedure TCheckInForm.FormShow(Sender: TObject);
begin
  MainForm.ToolButtonCheckIn.Enabled := false;
end;

end.
