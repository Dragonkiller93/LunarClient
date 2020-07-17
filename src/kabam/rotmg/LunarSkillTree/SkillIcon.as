package kabam.rotmg.LunarSkillTree {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.tooltip.TextToolTip;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.KeyCodes;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;

import kabam.rotmg.core.signals.HideTooltipsSignal;
import kabam.rotmg.core.signals.ShowTooltipSignal;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.tooltips.HoverTooltipDelegate;
import kabam.rotmg.tooltips.TooltipAble;

public class SkillIcon extends Sprite implements TooltipAble {

    protected static const mouseOverCT:ColorTransform = new ColorTransform(1, (220 / 0xFF), (133 / 0xFF));
    protected static const disableCT:ColorTransform = new ColorTransform(0.6, 0.6, 0.6, 1);

    public var hoverTooltipDelegate:HoverTooltipDelegate;
    protected var origIconBitmapData_:BitmapData;
    protected var iconBitmapData_:BitmapData;
    public var icon_:Bitmap;
    protected var label_:TextFieldDisplayConcrete;
    protected var hotkeyName_:String;
    protected var ct_:ColorTransform = null;
    public var toolTip_:TextToolTip = null;

    public function SkillIcon(ImageBitmap:BitmapData) {
        this.hoverTooltipDelegate = new HoverTooltipDelegate();
        super();
        this.icon_ = new Bitmap(ImageBitmap);

        addChild(this.icon_);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
    }
    public function setSize(_arg_1:int){
        this.width=this.height=this.icon_.width=this.icon_.height=_arg_1;
    }
    public function destroy():void {
        removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        this.hoverTooltipDelegate.removeDisplayObject();
        this.hoverTooltipDelegate.tooltip = null;
        this.hoverTooltipDelegate = null;
        this.origIconBitmapData_ = null;
        this.iconBitmapData_ = null;
        this.icon_ = null;
        this.label_ = null;
        this.toolTip_ = null;
    }

    public function setToolTipTitle(_arg_1:String, _arg_2:Object = null):void {
        if (_arg_1 != "") {
            if (this.toolTip_ == null) {
                this.toolTip_ = new TextToolTip(0x363636, 0x9B9B9B, "", "", 200);
                this.hoverTooltipDelegate.setDisplayObject(this);
                this.hoverTooltipDelegate.tooltip = this.toolTip_;
            }
            this.toolTip_.setTitle(new LineBuilder().setParams(_arg_1, _arg_2));
        }
    }

    public function setToolTipText(_arg_1:String, _arg_2:Object = null):void {
        if (_arg_1 != "") {
            if (this.toolTip_ == null) {
                this.toolTip_ = new TextToolTip(0x363636, 0x9B9B9B, "", "", 200);
                this.hoverTooltipDelegate.setDisplayObject(this);
                this.hoverTooltipDelegate.tooltip = this.toolTip_;
            }
            this.toolTip_.setText(new LineBuilder().setParams(_arg_1, _arg_2));
        }
    }

    public function setColorTransform(_arg_1:ColorTransform):void {
        if (_arg_1 == this.ct_) {
            return;
        }
        this.ct_ = _arg_1;
        if (this.ct_ == null) {
            transform.colorTransform = MoreColorUtil.identity;
        }
        else {
            transform.colorTransform = this.ct_;
        }
    }

    public function set enabled(_arg_1:Boolean):void {
        if (_arg_1) {
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this.setColorTransform(null);
            mouseEnabled = (mouseChildren = true);
        }
        else {
            removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this.setColorTransform(disableCT);
            mouseEnabled = (mouseChildren = false);
        }
    }

    protected function onMouseOver(_arg_1:MouseEvent):void {
        this.setColorTransform(mouseOverCT);
    }

    protected function onMouseOut(_arg_1:MouseEvent):void {
        this.setColorTransform(null);
    }

    public function setShowToolTipSignal(_arg_1:ShowTooltipSignal):void {
        this.hoverTooltipDelegate.setShowToolTipSignal(_arg_1);
    }

    public function getShowToolTip():ShowTooltipSignal {
        return (this.hoverTooltipDelegate.getShowToolTip());
    }

    public function setHideToolTipsSignal(_arg_1:HideTooltipsSignal):void {
        this.hoverTooltipDelegate.setHideToolTipsSignal(_arg_1);
    }

    public function getHideToolTips():HideTooltipsSignal {
        return (this.hoverTooltipDelegate.getHideToolTips());
    }


}
}//package com.company.assembleegameclient.ui.icons
