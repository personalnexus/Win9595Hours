program Win9595h;

uses
  Forms,
  MainF in 'MainF.PAS' {MainForm};

{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
