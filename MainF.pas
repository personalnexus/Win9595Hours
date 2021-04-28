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
    procedure FormCreate(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

const
  EventDuration: TDateTime = 95/24;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ClientHeight := TimeLeftLabel.Top  + TimeLeftLabel.Height + TimeLeftLabel.Top;
  UpdateTimeLeft(Sender);
end;

procedure TMainForm.UpdateTimeLeft(Sender: TObject);
var
  TimeLeft: TDateTime;

  function Format(const ValueFormat, NameSingular: string): string;
  var
    FormattedValue: string;
  begin
    FormattedValue := FormatDateTime(ValueFormat, TimeLeft);
    Result := FormattedValue + ' ' + NameSingular;
    if (FormattedValue <> '1') then begin
      Result := Result + 's';
    end;
  end;

  function FormatDays: string;
  var
    FormattedValue: string;
  begin
     FormattedValue := IntToStr(Trunc(TimeLeft));
     Result := FormattedValue + ' day';
     if (FormattedValue <> '1') then begin
        Result := Result + 's';
     end;
  end;

var
  CurrentTime:      TDateTime;
  Year, Month, Day: Word;
  StartThisYear:    TDateTime;
  EndThisYear:      TDateTime;
  StartNextYear:    TDateTime;
  LabelSuffix:      string;
begin
  CurrentTime := SysUtils.Now;
  DecodeDate(CurrentTime, Year, Month, Day);
  StartThisYear := EncodeDate(Year, 04, 24);
  EndThisYear := StartThisYear + EventDuration;
  if (CurrentTime < StartThisYear) then begin
    {Before}
    TimeLeft := StartThisYear - CurrentTime;
    LabelSuffix := 'until #95HoursWithWindows95 begins this year.';
  end else if (StartThisYear <= CurrentTime) and (CurrentTime <= EndThisYear) then begin
    {During}
    TimeLeft := EndThisYear - CurrentTime;
    LabelSuffix := 'left with #95HoursWithWindows95 in ' + IntToStr(Year) + '.';
  end else begin
    {After}
    StartNextYear := EncodeDate(Year + 1, 04, 24) + EventDuration;
    TimeLeft := StartNextYear - CurrentTime;
    LabelSuffix := 'until #95HoursWithWindows95 next year.';
  end;
  TimeLeftLabel.Caption := FormatDays + ', '+
                           Format('H', 'hour') + ', ' +
                           Format('N', 'minute') + ', ' +
                           Format('S', 'second') + ' ' + LabelSuffix;
   ClientWidth := TimeLeftLabel.Left + TimeLeftLabel.Width  + TimeLeftLabel.Left;
end;


end.
