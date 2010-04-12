object MainForm: TMainForm
  Left = 281
  Top = 277
  BorderStyle = bsNone
  Caption = 'SSG'#39's Matrix'
  ClientHeight = 208
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = TURKISH_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object tmTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = tmTimerTimer
    Left = 8
    Top = 8
  end
end
