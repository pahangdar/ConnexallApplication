unit AppointmentsDataAccessUnit;

interface

uses
  PatientUnit, DoctorUnit, AppointmentUnit, DataModuleUnit, AppointmentsUtils,
  System.SysUtils, System.Generics.Collections, Vcl.Dialogs, FireDAC.Comp.Client;

type
  TAppointmentsDataAccess = class
  public
    class function QueryToAppointment(Query: TFDQuery): TAppointment;
    class function GetAppointmentsByDate(SelectedDate: TDateTime): TObjectList<TAppointment>;
    class function GetAppointment(AppointmentID: Integer): TAppointment;
    class function UpdateAppointmentStatus(AppointmentID: Integer; NewStatus: string): Boolean;
  end;

implementation

class function TAppointmentsDataAccess.UpdateAppointmentStatus(AppointmentID: Integer; NewStatus: string): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    if not DataModuleMain.FDConnection1.Connected then
      DataModuleMain.ConnectToDatabase;

    Query.Connection := DataModuleMain.FDConnection1;
    Query.SQL.Text :=
      'UPDATE Appointments ' +
      'SET Status = :Status ' +
      'WHERE AppointmentID = :AppointmentID';

    Query.ParamByName('Status').AsString := NewStatus;
    Query.ParamByName('AppointmentID').AsInteger := AppointmentID;

    Query.ExecSQL;

    Result := Query.RowsAffected > 0;
  except
    on E: Exception do
    begin
      ShowMessage('Error updating appointment status: ' + E.Message);
    end;
  end;

  Query.Free;
end;

class function TAppointmentsDataAccess.QueryToAppointment(Query: TFDQuery): TAppointment;
begin
  Result := TAppointment.Create(
    Query.FieldByName('AppointmentID').AsInteger,
    Query.FieldByName('Date').AsDateTime,
    Query.FieldByName('Time').AsDateTime,
    TPatient.Create(
      Query.FieldByName('PatientID').AsInteger,
      Query.FieldByName('FirstName').AsString,
      Query.FieldByName('LastName').AsString,
      Query.FieldByName('PhoneNumber').AsString,
      Query.FieldByName('Address').AsString,
      Query.FieldByName('DateOfBirth').AsDateTime,
      Query.FieldByName('Email').AsString
    ),
    TDoctor.Create(
      Query.FieldByName('DoctorID').AsInteger,
      Query.FieldByName('DoctorFirstName').AsString,
      Query.FieldByName('DoctorLastName').AsString,
      Query.FieldByName('Specialization').AsString,
      '', '' // Additional fields can be handled here
    ),
    StringToAppointmentStatus(Query.FieldByName('Status').AsString)
  );
end;

class function TAppointmentsDataAccess.GetAppointment(AppointmentID: Integer): TAppointment;
var
  Query: TFDQuery;
begin
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
                      'WHERE a.AppointmentID = :SelectedAppointment ' +
                      'ORDER BY a.Time, a.Status, a.PatientID';
    Query.ParamByName('SelectedAppointment').AsInteger := AppointmentID;

    Query.Open;

    if not Query.IsEmpty then
      Result := QueryToAppointment(Query)
    else
      raise Exception.Create('Appointment not found.');

  finally
    Query.Free;
  end;
end;

class function TAppointmentsDataAccess.GetAppointmentsByDate(SelectedDate: TDateTime): TObjectList<TAppointment>;
var
  Query: TFDQuery;
  AppointmentList: TObjectList<TAppointment>;
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
      AppointmentList.Add(QueryToAppointment(Query));
      Query.Next;
    end;

    Result := AppointmentList;

  finally
    Query.Free;
  end;
end;

end.
