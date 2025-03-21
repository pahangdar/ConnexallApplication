unit TestWebSocketClient;

interface

uses
  DUnitX.TestFramework, WebSocketClientUnit, System.SysUtils;

type
  [TestFixture]
  TWebSocketClientTests = class
  private
    FClient: TWebSocketClient;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestSingletonInstance;

    [Test]
    procedure TestConnect;

    [Test]
    procedure TestRequestAppID;

    [Test]
    procedure TestStartVerification;
  end;

implementation

uses
  PatientUnit;

procedure TWebSocketClientTests.Setup;
begin
  // Ensure we are working with a fresh instance
  FClient := TWebSocketClient.Instance;
end;

procedure TWebSocketClientTests.TearDown;
begin
  // Cleanup after each test
//  FClient.Disconnect;
end;

procedure TWebSocketClientTests.TestSingletonInstance;
begin
  Assert.IsNotNull(FClient, 'Instance should not be nil');
  Assert.AreSame(FClient, TWebSocketClient.Instance, 'Instance should be a singleton');
end;

procedure TWebSocketClientTests.TestConnect;
begin
  FClient.Connect;
  Assert.IsTrue(FClient.IsConnected, 'WebSocket should be connected');
end;

procedure TWebSocketClientTests.TestRequestAppID;
begin
  Assert.WillNotRaise(
    procedure
    begin
      FClient.RequestAppID;
    end, Exception, 'RequestAppID should not raise an exception');
end;

procedure TWebSocketClientTests.TestStartVerification;
var
  Patient: TPatient;
  Success: Boolean;
begin
  Patient := TPatient.Create;
  try
    Patient.FirstName := 'John';
    Patient.LastName := 'Doe';
    Patient.PhoneNumber := '1234567890';
    Patient.Address := '123 Main St';
    Patient.DateOfBirth := EncodeDate(1990, 1, 1);

    Success := FClient.StartVerification(1, 'delphi_1', 'kiosk_1', Patient);
    Assert.IsTrue(Success, 'StartVerification should return true');
  finally
    Patient.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebSocketClientTests);

end.

