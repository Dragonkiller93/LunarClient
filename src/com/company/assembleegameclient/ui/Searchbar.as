package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.account.ui.TextInputField;

import flash.display.Sprite;
import flash.events.Event;


public class Searchbar extends Sprite{
    public var field:TextInputField;
    private var onInput:Function;
    public function Searchbar(_arg_1:Function) {
        createField();
        onInput = _arg_1;
    }
    private function createField():void{
        field = new TextInputField("",false);
        field.inputText_.addEventListener(Event.CHANGE,createFunction);
        addChild(field);
    }
    private function createFunction(_arg_1:Event):void{
        onInput(field.text());
    }
}
}
