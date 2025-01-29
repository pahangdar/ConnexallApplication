unit AppointmentsAPIUnit;

interface

uses
  System.SysUtils, System.Net.HttpClient, System.Net.URLClient, System.JSON,
  System.Generics.Collections, System.DateUtils, System.Classes, Vcl.Dialogs,
  System.IniFiles, System.Net.Mime,
  AppointmentUnit, PatientUnit, DoctorUnit, AppointmentsUtils, EventManagerUnit;

type
  TAppointmentsAPI = class
  private
    class var FBaseURL: string;
    class var FHttpClient: THTTPClient;
    class var FAPIKey: string;
    class constructor Create;
    class destructor Destroy;

    class function ParseAppointmentFromJSON(const JSONObj: TJSONObject): TAppointment;
    class procedure Initialize;
  public
    class property BaseURL: string read FBaseURL write FBaseURL;

    class function GetAppointmentsByDate(ADate: TDateTime): TObjectList<TAppointment>;
    class function GetAppointmentByID(AID: Integer): TAppointment;
    class function UpdateAppointmentStatus(AID: Integer; const AStatus: string): Boolean;
  end;

implementation

{ TAppointmentsAPI }

class constructor TAppointmentsAPI.Create;
begin
  Initialize;
  FHttpClient := THTTPClient.Create;
end;

class destructor TAppointmentsAPI.Destroy;
begin
  FHttpClient.Free;
end;

class procedure TAppointmentsAPI.Initialize;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    FBaseURL := IniFile.ReadString('API', 'BaseURL', '');
    FAPIKey := IniFile.ReadString('API', 'APIKey', '');
  finally
    IniFile.Free;
  end;
end;

class function TAppointmentsAPI.ParseAppointmentFromJSON(const JSONObj: TJSONObject): TAppointment;
var
  PatientObj, DoctorObj: TJSONObject;
begin
  Result := TAppointment.Create;

  Result.AppointmentID := JSONObj.GetValue<Integer>('appointmentID');
  Result.Date := ISO8601ToDate(JSONObj.GetValue<string>('date'));
  Result.Time := StrToTime(JSONObj.GetValue<string>('time'));
  Result.Status := StringToAppointmentStatus(JSONObj.GetValue<string>('status'));

  PatientObj := JSONObj.GetValue<TJSONObject>('patient');
  if Assigned(PatientObj) then
  begin
    Result.Patient := TPatient.Create;
    Result.Patient.PatientID := PatientObj.GetValue<Integer>('patientID');
    Result.Patient.FirstName := PatientObj.GetValue<string>('firstName');
    Result.Patient.LastName := PatientObj.GetValue<string>('lastName');
    Result.Patient.PhoneNumber := PatientObj.GetValue<string>('phoneNumber');
    Result.Patient.Address := PatientObj.GetValue<string>('address');
    // other fields
  end;

  DoctorObj := JSONObj.GetValue<TJSONObject>('doctor');
  if Assigned(DoctorObj) then
  begin
    Result.Doctor := TDoctor.Create;
    Result.Doctor.DoctorID := DoctorObj.GetValue<Integer>('doctorID');
    Result.Doctor.FirstName := DoctorObj.GetValue<string>('firstName');
    Result.Doctor.LastName := DoctorObj.GetValue<string>('lastName');
    // other fields
  end;
end;

class function TAppointmentsAPI.GetAppointmentsByDate(ADate: TDateTime): TObjectList<TAppointment>;
var
  Response: IHTTPResponse;
  JSONArray: TJSONArray;
  JSONValue: TJSONValue;
  Appointment: TAppointment;
  URL: string;
begin
  Result := TObjectList<TAppointment>.Create;
  try
    URL := FBaseURL + '/api/Appointments/date/' + FormatDateTime('yyyy-mm-dd', ADate);
    Response := FHttpClient.Get(URL, nil,
    [TNameValuePair.Create('X-API-Key', FAPIKey)]);

    if Response.StatusCode = 200 then
    begin
      JSONArray := TJSONObject.ParseJSONValue(Response.ContentAsString(TEncoding.UTF8)) as TJSONArray;

      for JSONValue in JSONArray do
      begin
        Appointment := ParseAppointmentFromJSON(JSONValue as TJSONObject);
        Result.Add(Appointment);
      end;
    end
    else
      raise Exception.CreateFmt('Failed to retrieve appointments: %s', [Response.StatusText]);
  except
    Result.Free;
    raise;
  end;
end;

class function TAppointmentsAPI.GetAppointmentByID(AID: Integer): TAppointment;
var
  Response: IHTTPResponse;
  JSONObj: TJSONObject;
  URL: string;
begin
  URL := FBaseURL + '/api/Appointments/' + AID.ToString;
  Response := FHttpClient.Get(URL, nil,
    [TNameValuePair.Create('X-API-Key', FAPIKey)]);

  if Response.StatusCode = 200 then
  begin
    JSONObj := TJSONObject.ParseJSONValue(Response.ContentAsString(TEncoding.UTF8)) as TJSONObject;
    try
      Result := ParseAppointmentFromJSON(JSONObj);
    finally
      JSONObj.Free;
    end;
  end
  else
    raise Exception.CreateFmt('Failed to retrieve appointment: %s', [Response.StatusText]);
end;

class function TAppointmentsAPI.UpdateAppointmentStatus(AID: Integer; const AStatus: string): Boolean;
var
  Response: IHTTPResponse;
  URL: string;
  EmptyStream: TBytesStream;
  Headers: TNetHeaders;
  FormData: TMultipartFormData;
begin
  URL := Format('%s/api/Appointments/status/%d?status=%s', [FBaseURL, AID, AStatus]);
  FormData := TMultipartFormData.Create;
  EmptyStream := TBytesStream.Create(nil);
  try
    Headers := [TNetHeader.Create('X-API-Key', FAPIKey)];
//    Response := FHttpClient.Put(URL, EmptyStream, Headers);
    Response := FHttpClient.Put(URL, FormData, nil, Headers);
    Result := (Response.StatusCode = 200) OR (Response.StatusCode = 204);
    if Result then
      TEventManager.Instance.NotifyAppointmentUpdated('appointments')
    else
      raise Exception.CreateFmt('Failed to update appointment status: %s', [Response.StatusText]);
  finally
    EmptyStream.Free;
  end;
end;

end.

