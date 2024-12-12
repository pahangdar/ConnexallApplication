unit AppointmentUnit;

interface

uses PatientUnit, DoctorUnit;

type
  TAppointmentStatus = (Pending, Confirming, Confirmed, Canceld, Completed);

  TAppointment = class
  private
    FAppointmentID: Integer;
    FDate: TDateTime;
    FTime: TDateTime;
    FPatient: TPatient;
    FDoctor: TDoctor;
    FStatus: TAppointmentStatus;

  public
    constructor Create(
      AAppointmentID: Integer;
      ADate: TDateTime;
      ATime: TDateTime;
      APatient: TPatient;
      ADoctor: TDoctor;
      AStatus: TAppointmentStatus
    );

    property AppointmentID: Integer read FAppointmentID write FAppointmentID;
    property Date: TDateTime read FDate write FDate;
    property Time: TDateTime read FTime write FTime;
    property Patient: TPatient read FPatient write FPatient;
    property Doctor: TDoctor read FDoctor write FDoctor;
    property Status: TAppointmentStatus read FStatus write FStatus;

  end;

implementation

constructor TAppointment.Create(AAppointmentID: Integer; ADate: TDateTime; ATime: TDateTime; APatient: TPatient; ADoctor: TDoctor; AStatus: TAppointmentStatus);
begin
  FAppointmentID := AAppointmentID;
  FDate := ADate;
  FTime := ATime;
  FPatient := APatient;
  FDoctor := ADoctor;
  FStatus := AStatus
end;

end.
