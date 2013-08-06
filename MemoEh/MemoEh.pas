unit MemoEh;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Messages, Windows, Graphics;

type
  TMemoEh = class(TMemo)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure WMNCPAINT(var msg: TWMNCPaint); message WM_NCPAINT;
    procedure InvalidateNC;
    procedure CMMouseEnter(var msg: TMessage);message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage);message CM_MOUSELEAVE;
  public
    { Public declarations }

  published
    { Published declarations }
  end;

var
  FMouseIn: Boolean;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('My', [TMemoEh]);
end;

procedure  TMemoEh.WMNCPAINT(var  msg:  TWMNCPaint);
var
  DC:  HDC;
  BorderBrush:  HBRUSH;
  R:  TRect;
begin
  DC  :=  GetWindowDC(Handle);
  try
    SetRect(R,0,0,Width,Height);
    if  FMouseIn  then
    begin
      BorderBrush  :=  CreateSolidBrush(RGB(123,228,255));//创建画刷
      FrameRect(Dc,  R,  BorderBrush);//绘制外部的高亮边框
        DeleteObject(BorderBrush);
      InflateRect(R,-1,-1);
    end
    else
    begin
      InflateRect(R,-1,-1);
      BorderBrush  :=  CreateSolidBrush(ColortoRGB(Color));
      FrameRect(Dc,  R,  BorderBrush);//这个是因为如果鼠标不在上面，就要用本身的颜色填充内部线框
        DeleteObject(BorderBrush);
      InflateRect(R,1,1);
    end;
    BorderBrush  :=  CreateSolidBrush(RGB(78,160,209));
    FrameRect(Dc,  R,  BorderBrush);//绘制默认的边线框
    DeleteObject(BorderBrush);
  finally
    ReleaseDC(Handle,DC)
  end;
end;

procedure TMemoEh.InvalidateNC;
begin
  if  Parent  =  nil  then  Exit;
  SendMessage(Handle, WM_NCPAINT, 0, 0);
end;

procedure TMemoEh.CMMouseEnter(var msg: TMessage);
begin
  inherited;
  FMouseIn := True;
  InvalidateNC;
end;

procedure TMemoEh.CMMouseLeave(var msg: TMessage);
begin
  inherited;
  FMouseIn := False;
  InvalidateNC;
end;

end.


