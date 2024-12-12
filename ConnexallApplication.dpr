program ConnexallApplication;

uses
  Vcl.Forms,
  MainFormUnit in 'Forms\MainFormUnit.pas' {MainForm},
  CheckInFormUnit in 'Forms\CheckInFormUnit.pas' {CheckInForm},
  Vcl.Themes,
  Vcl.Styles,
  PatientUnit in 'Modules\PatientUnit.pas',
  DoctorUnit in 'Modules\DoctorUnit.pas',
  AppointmentUnit in 'Modules\AppointmentUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Connexall Application';
  TStyleManager.TrySetStyle('Lavender Classico');
  Application.CreateForm(TMainForm, MainForm);
  //  Application.CreateForm(TCheckInForm, CheckInForm);
  Application.Run;
end.
