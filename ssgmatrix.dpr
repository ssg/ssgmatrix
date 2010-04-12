program SSGMatrix;

uses
  Forms,
  Dialogs,
  mainfrm in 'mainfrm.pas' {MainForm};

{$E scr}

{$R *.res}

var
  c:char;
begin
  c := 'S';
  Application.Initialize;
  Application.Title := 'SSG''s Matrix ScreenSaver';
  if ParamCount > 0 then begin
    if ParamStr(1) = '/s' then begin
      Application.CreateForm(TMainForm, MainForm);
      Application.Run;
    end else if pos('/c',ParamStr(1))=1 then begin
      MessageDlg(c+c+'G''s Matrix ScreenSaver'#13#13+appVer+#13#13'Coded by'#13'Sedat "'+c+c+'G" Kapanoglu'#13#13'ssg@sourtimes.org'#13'http://ssg.sourtimes.org',mtInformation,[mbOK],0);
    end;
  end;
end.
