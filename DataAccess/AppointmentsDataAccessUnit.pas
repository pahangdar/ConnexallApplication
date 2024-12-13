unit AppointmentsDataAccessUnit;

interface

uses
  PatientUnit, DoctorUnit, AppointmentUnit, DataModuleUnit, AppointmentsUtils, System.SysUtils, System.Generics.Collections, Vcl.Dialogs;

type
  TAppointmentsDataAccess = class
  public
    class function GetAppointmentsByDate(SelectedDate: TDateTime): TObjectList<TAppointment>;
  end;

implementation

uses
  FireDAC.Comp.Client;

class function TAppointmentsDataAccess.GetAppointmentsByDate(SelectedDate: TDateTime): TObjectList<TAppointment>;
var
  Query: TFDQuery;
  AppointmentList: TObjectList<TAppointment>;
  Appointment: TAppointment;
begin
  AppointmentList := TObjectList<TAppointment>.Create(True);
  Query := TFDQuery.Create(nil);
  try
    if not DataModuleMain.FDConnection1.Connected then
      DataModuleMain.ConnectToDatabase;

    Query.Connection := DataModuleMain.FDConnection1;

    Query.SQL.Text := 'SELECT a.AppointmentID, a.Date, a.Time, a.Status, ' +
                      'p.PatientID, p.FirstName, p.LastName, p.PhoneNumber, p.Address, p.DateOfBirth, p.Email, ' +
                      'd.DoctorID, d.FirstName AS DoctorFirstName, d.LastName AS DoctorLastName, d.Specialization ' +
                      'FROM Appointments a ' +
                      'JOIN Patients p ON a.PatientID = p.PatientID ' +
                      'JOIN Doctors d ON a.DoctorID = d.DoctorID ' +
                      'WHERE a.Date = :SelectedDate ' +
                      'ORDER BY a.Time, a.Status, a.PatientID';
    Query.ParamByName('SelectedDate').AsDate := SelectedDate;

    Query.Open;

    while not Query.Eof do
    begin
      var Patient := TPatient.Create(
        Query.FieldByName('PatientID').AsInteger,
        Query.FieldByName('FirstName').AsString,
        Query.FieldByName('LastName').AsString,
        Query.FieldByName('PhoneNumber').AsString,
        Query.FieldByName('Address').AsString,
        Query.FieldByName('DateOfBirth').AsDateTime,
        Query.FieldByName('Email').AsString
      );

      var Doctor := TDoctor.Create(
        Query.FieldByName('DoctorID').AsInteger,
        Query.FieldByName('DoctorFirstName').AsString,
        Query.FieldByName('DoctorLastName').AsString,
        Query.FieldByName('Specialization').AsString,
        '', '' // Optional fields for phone and email
      );

      Appointment := TAppointment.Create(
        Query.FieldByName('AppointmentID').AsInteger,
        Query.FieldByName('Date').AsDateTime,
        Query.FieldByName('Time').AsDateTime,
        Patient,
        Doctor,
        StringToAppointmentStatus(Query.FieldByName('Status').AsString)
      );

      AppointmentList.Add(Appointment);

      Query.Next;
    end;

    Result := AppointmentList;

  finally
    Query.Free;
  end;
end;

end.
