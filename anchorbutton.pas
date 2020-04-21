unit anchorbutton;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics;


type
  TAnchorBaseButton = class(TGraphicControl)
  private
    FGlyphs: TBitmap;
    FFocused: boolean;
    FPressed: boolean;
    FLastResource: string;

    procedure SetGlyphs(const ABitmap: TBitmap);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure SetEnabled(Value: boolean); override;

    procedure CalculatePreferredSize(var PreferredWidth, PreferredHeight: integer;
      WithThemeSpace: boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoadFromResourceName(const ResName: String);

    property Glyphs: TBitmap read FGlyphs write SetGlyphs;
  end;

implementation uses Forms;

// ANCHOR_CLOSE, ANCHOR_CLOSE_WIDE, ANCHOR_PIN, ANCHOR_UNPIN
{$r anchordockbutton.res}

{ TAnchorBaseButton }
constructor TAnchorBaseButton.Create(AOwner: TComponent);
begin
  inherited;
  FGlyphs := TBitmap.Create;
  AutoSize := true;
end;


procedure TAnchorBaseButton.CalculatePreferredSize(
  var PreferredWidth, PreferredHeight: integer; WithThemeSpace: boolean);
begin
  if FGlyphs.Width > 0 then
  begin
    PreferredWidth := FGlyphs.Width div 4;
    PreferredHeight := FGlyphs.Height;
  end
  else
  begin
    PreferredWidth := 23;
    PreferredHeight := 22;
  end;
    {$IF defined(LCLGtk2) or defined(Carbon)}
  Inc(PreferredWidth, 2);
  Inc(PreferredHeight, 2);
    {$ENDIF}
  PreferredWidth := ScaleDesignToForm(PreferredWidth);
  PreferredHeight := ScaleDesignToForm(PreferredHeight);
end;

destructor TAnchorBaseButton.Destroy;
begin
  FGlyphs.Free;
  inherited;
end;

procedure TAnchorBaseButton.Paint;
var
  index: integer;
  R: TRect;
  w: integer;
begin
  index := 0;
  if not Enabled then
    index := 1
  else
  begin
    if FFocused then
      index := 2;
    if FPressed then
      index := 3;
  end;
  w := FGlyphs.Width div 4;
  R := Rect(index * w, 0, (index + 1) * w, FGlyphs.Height);

  Canvas.CopyRect(Rect(0, 0, Width, Height), FGlyphs.Canvas, R);
end;

procedure TAnchorBaseButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited;
  FPressed := True;
  invalidate;
end;

procedure TAnchorBaseButton.MouseEnter;
begin
  inherited;
  FFocused := True;
  invalidate;
end;

procedure TAnchorBaseButton.MouseLeave;
begin
  inherited;
  FFocused := False;
  invalidate;
end;

procedure TAnchorBaseButton.SetEnabled(Value: boolean);
begin
  inherited;
  invalidate;
end;

procedure TAnchorBaseButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited;
  FPressed := False;
  invalidate;
end;

procedure TAnchorBaseButton.SetGlyphs(const ABitmap: TBitmap);
begin
  FGlyphs.Assign(ABitmap);
  AdjustSize;
  invalidate;
end;

procedure TAnchorBaseButton.LoadFromResourceName(const ResName: String);
begin
  if FLastResource=ResName then exit;
  FLastResource := ResName;

  FGlyphs.LoadFromResourceName(hinstance, ResName);

  InvalidatePreferredSize;

  if Assigned(GetParentDesignControl(self)) then
   DoAutoSize;

  invalidate;
end;

end.

