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

   procedure SetGlyphs(const ABitmap: TBitmap);
 protected
   procedure Paint; override;
   procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
     X, Y: integer); override;
   procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
   procedure MouseEnter; override;
   procedure MouseLeave; override;
   procedure SetEnabled(Value: boolean); override;
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   property Glyphs: TBitmap read FGlyphs write SetGlyphs;
 end;

implementation

{$r anchordockbutton.res}

{ TAnchorBaseButton }
constructor TAnchorBaseButton.Create(AOwner: TComponent);
begin
  inherited;
  Width := 23;
  Height := 22;
  FGlyphs := TBitmap.Create;
end;

destructor TAnchorBaseButton.Destroy;
begin
  FGlyphs.Free;
  inherited;
end;

procedure TAnchorBaseButton.paint;
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
  invalidate;
end;


end.

