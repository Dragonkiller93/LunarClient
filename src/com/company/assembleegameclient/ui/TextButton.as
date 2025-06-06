package com.company.assembleegameclient.ui {
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

import org.osflash.signals.Signal;

public class TextButton extends TextButtonBase {

    public const textChanged:Signal = new Signal();

    public function TextButton(_arg1:int, _arg2:String, _arg3:int = 0, _arg4:Boolean = false) {
        super(_arg3);
        addText(_arg1);
        if (_arg4) {
            text_.setStringBuilder(new StaticStringBuilder(_arg2));
        }
        else {
            text_.setStringBuilder(new LineBuilder().setParams(_arg2));
        }
        text_.textChanged.addOnce(this.onTextChanged);
    }
    public function changeColor(_arg_1:int):void{
        this.text_.setColor(_arg_1);
    }
    protected function onTextChanged():void {
        initText();
        this.textChanged.dispatch();
    }


}
}