{
SSG's Matrix ScreenSaver
mainfrm.pas

Coded by SSG obviously
}
unit mainfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

const
  appVer = '1.01';
  fontName = 'Matrix Code Font';
  fontHeight = 12;
  maxStreams = 5000;
  maxSpeed = 4;
  minSpeed = 1;
  baseDelay = 50;

  matrixAlphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcd';
  matrixAlphabetLength = length(matrixAlphabet);

  maxR = 150;
  maxB = 100;

type
  PMatrixStream = ^TMatrixStream;
  TMatrixStream = record
    x,y:integer;
    speed:integer;
    brightness:integer;
    lastchar:char;
    lastcharindex:byte;
  end;

  TMainForm = class(TForm)
    tmTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmTimerTimer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    outCanvas:TCanvas;
    matrixWidth,matrixHeight,charWidth,charHeight:integer;
    bitmapWidth,bitmapHeight:integer;
    procedure Init;
    procedure Iterate;
    procedure AdjustBitmap;
    procedure InitStreams;
    procedure AddStream;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

var
  streams : array[0..maxStreams-1] of TMatrixStream;
  streamCount : integer;
  tick : integer;

procedure TMainForm.Init;
var
  n:integer;
  R:TRect;
begin
  tick := 0;
  Randomize;
  outCanvas := Self.Canvas;

  FillChar(R,SizeOf(R),0);
  with Screen do begin
    for n:=0 to MonitorCount-1 do begin
      with Monitors[n] do begin
        if BoundsRect.Left < R.Left then R.Left := BoundsRect.Left;
        if BoundsRect.Top < R.Top then R.Top := BoundsRect.Top;
        if BoundsRect.Right > R.Right then R.Right := BoundsRect.Right;
        if BoundsRect.Bottom > R.Bottom then R.Bottom := BoundsRect.Bottom;
      end;
    end;
  end;
  Self.BoundsRect := R;
  bitmapWidth := Width;
  bitmapHeight := Height;
  AdjustBitmap;
  tmTimer.Interval := baseDelay;
  tmTimer.Enabled := true;
  Screen.Cursor := crNone;
end;

procedure TMainForm.AddStream;
begin
  if streamCount>=maxStreams then exit;
  with streams[streamCount] do begin
    x := streamCount mod matrixWidth;
    y := random(matrixHeight);
    speed := Random(maxSpeed-minSpeed)+minSpeed;
    brightness := Random(100);
    lastcharindex := Random(matrixAlphabetLength)+1;
  end;
  inc(streamCount);
end;

procedure TMainForm.InitStreams;
var
  n:integer;
begin
  streamCount := 0;
  for n:=1 to matrixWidth*2 do addStream;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Init;
end;

procedure TMainForm.Iterate;
var
  n,c1,c2:integer;
  stream:PMatrixStream;

  procedure PutChar(c:char);
  begin
    with outCanvas,stream^ do begin
      c1 := x*charWidth;
      c2 := y-40;
      while c2 < 0 do c2 := (matrixHeight+1)+c2;
      c2 := c2*charHeight;
      FillRect(Rect(c1,c2,c1+charWidth,c2+charHeight));
      c1 := (255*brightness) div 100;
      c2 := c1 div 3;
      c1 := (c1*maxR div 255) or (c1 shl 8) or ((c1*maxB div 255) shl 16);
      c2 := (c2*maxR div 255) or (c2 shl 8) or ((c2*maxB div 255) shl 16);
      if(y > 0) then begin
        Font.Color := c2;
        TextOut(x*charWidth,(y-1)*charHeight,lastchar);
      end;
      Font.Color := c1;
      TextOut(x*charWidth,y*charHeight,c);
      lastchar := c;
    end;
  end;
begin
  for n:=0 to streamCount-1 do begin
    stream := @streams[n];
    with stream^ do begin
      if tick mod speed = 0 then begin
        PutChar(matrixAlphabet[Random(matrixAlphabetLength)]);
        inc(y);
        if(y > matrixHeight+1) then begin
          y := 0;
          speed := Random(maxSpeed-minSpeed)+minSpeed;
          brightness := Random(100);
        end;
      end else begin
        PutChar(matrixAlphabet[Random(matrixAlphabetLength)]);
      end;
    end;
  end;
  inc(tick);
end;

procedure TMainForm.tmTimerTimer(Sender: TObject);
begin
  Iterate;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  outCanvas.FillRect(BoundsRect);
end;

procedure TMainForm.AdjustBitmap;
begin
  with outCanvas do begin
    TextFlags := 0;
    Brush.Color := clBlack;
    FillRect(Rect(0,0,Width,Height));
    Font.Name := fontName;
    Font.Height := fontHeight;
    charWidth := fontHeight-4;
    charHeight := fontHeight;
    matrixWidth := bitmapWidth div charWidth;
    matrixHeight := bitmapHeight div charHeight;
  end;
  InitStreams;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  AdjustBitmap;
end;

var
  lastx:integer = 0;
  lasty:integer = 0;

procedure TMainForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (lastx=0) and (lasty=0) then begin
    lastx := x;
    lasty := y;
  end else begin
    if (abs(x-lastx) > 10) or (abs(y-lasty) > 10) then begin
      Close;
    end;
  end;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Close;
end;

procedure TMainForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Close;
end;

end.
