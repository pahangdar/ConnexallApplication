unit AppointmentUnit;

interface

uses
  System.SysUtils, PatientUnit, DoctorUnit;

type
  TAppointmentStatus = (asPending, asConfirming, asConfirmed, asNotConfirmed, asCancelled, asCompleted);

  TAppointment = class
  private
    FAppointmentID: Integer;
    FDate: TDateTime;
    FTime: TDateTime;
    FPatient: TPatient;
    FDoctor: TDoctor;
    FStatus: TAppointmentStatus;

    procedure SetStatus(AStatus: TAppointmentStatus);
  public
    constructor Create; overload;
    constructor Create(
      AAppointmentID: Integer;
      ADate: TDateTime;
      ATime: TDateTime;
      const APatient: TPatient;
      const ADoctor: TDoctor;
      AStatus: TAppointmentStatus
    ); overload;
    destructor Destroy; override;

    property AppointmentID: Integer read FAppointmentID write FAppointmentID;
    property Date: TDateTime read FDate write FDate;
    property Time: TDateTime read FTime write FTime;
    property Patient: TPatient read FPatient write FPatient;
    property Doctor: TDoctor read FDoctor write FDoctor;
    property Status: TAppointmentStatus read FStatus write SetStatus;

  end;

implementation

uses AppointmentsUtils;

constructor TAppointment.Create;
begin
  inherited Create;
  FAppointmentID := -1;
  FDate := 0;
  FTime := 0;
  FPatient := nil;
  FDoctor := nil;
  FStatus := asPending;
end;

constructor TAppointment.Create(AAppointmentID: Integer; ADate: TDateTime; ATime: TDateTime; const APatient: TPatient; const ADoctor: TDoctor; AStatus: TAppointmentStatus);
begin
  inherited Create;
  if AAppointmentID <= 0 then
    raise Exception.Create('Invalid Appointment ID.');
  if APatient = nil then
    raise Exception.Create('Patient cannot be nil.');
  if ADoctor = nil then
    raise Exception.Create('Doctor cannot be nil.');
  if not IsValidStatus(AStatus) then
    raise Exception.Create('Invalid appointment status.');

  FAppointmentID := AAppointmentID;
  FDate := ADate;
  FTime := ATime;
  FPatient := APatient;
  FDoctor := ADoctor;
  FStatus := AStatus
end;

procedure TAppointment.SetStatus(AStatus: TAppointmentStatus);
begin
  if IsValidStatus(AStatus) then
    FStatus := AStatus
  else
    raise Exception.Create('Invalid appointment status.');
end;

destructor TAppointment.Destroy;
begin
  FreeAndNil(FPatient);
  FreeAndNil(FDoctor);
  inherited;
end;

end.
