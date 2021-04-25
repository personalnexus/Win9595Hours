unit MainF;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TMainForm = class(TForm)
    TimeLeftLabel: TLabel;
    TimeLeftTimer: TTimer;
    procedure UpdateTimeLeft(Sender: TObject);
  private
    procedure AdjustSize;
    function Hours(X: Integer): TDateTime;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.UpdateTimeLeft(Sender: TObject);
var
  CurrentTime:      TDateTime;
  Year, Month, Day: Word;
  StartThisYear:    TDateTime;
  EndThisYear:      TDateTime;
  StartNextYear:    TDateTime;
  TimeLeft:         TDateTime;
  LabelSuffix:      string;
begin
  CurrentTime := SysUtils.Now;
  DecodeDate(CurrentTime, Year, Month, Day);
  StartThisYear := EncodeDate(Year, 04, 24);
  EndThisYear := StartThisYear + Hours(95);
  if (CurrentTime < StartThisYear) then begin
    {Before}
    TimeLeft := StartThisYear - CurrentTime;
    LabelSuffix := 'until #95HoursWithWindows95 begins"';
  end else if (StartThisYear <= CurrentTime) and (CurrentTime <= EndThisYear) then begin
    {During}
    TimeLeft := EndThisYear - CurrentTime;
    LabelSuffix := 'left in #95HoursWithWindows95';
  end else begin
    {After}
    StartNextYear := EncodeDate(Year + 1, 04, 24) + Hours(95);
    TimeLeft := StartNextYear - CurrentTime;
    LabelSuffix := 'until in #95HoursWithWindows95 next year';
  end;
  TimeLeftLabel.Caption := FormatDateTime('D" days, "N" minutes, "S" seconds "', TimeLeft) + LabelSuffix;
  AdjustSize;
end;

{ Helper methods }

function TMainForm.Hours(X: Integer): TDateTime;
begin
  {TDateTime is an OLE Automation date, where 1.0 = 1 day.
   Hence, X hours are X * 1/24 of one day}
  Result := X / 24;
end;

procedure TMainForm.AdjustSize;
begin
  ClientHeight := TimeLeftLabel.Top  + TimeLeftLabel.Height + TimeLeftLabel.Top;
  ClientWidth  := TimeLeftLabel.Left + TimeLeftLabel.Width  + TimeLeftLabel.Left;
end;


end.