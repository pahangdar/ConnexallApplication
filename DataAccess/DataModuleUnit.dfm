object DataModuleMain: TDataModuleMain
  Height = 750
  Width = 1000
  PixelsPerInch = 120
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=Connexall'
      'User_Name=sa'
      'Server=DESKTOP-3U2UH42\MSSQLSERVER2012'
      'DriverID=MSSQL')
    LoginPrompt = False
    Left = 736
    Top = 512
  end
end
