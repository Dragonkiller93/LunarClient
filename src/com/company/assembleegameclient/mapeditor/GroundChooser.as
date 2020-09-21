package com.company.assembleegameclient.mapeditor {
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.ui.Searchbar;
import com.company.util.MoreStringUtil;

class GroundChooser extends Chooser {
    private var fullElements:Vector.<Element> = new Vector.<Element>();
    private var elements:Vector.<String>;
    public function GroundChooser() {
        var _local_1:String;
        var _local_3:int;
        var _local_4:GroundElement;
        super(Layer.GROUND);
        elements= new Vector.<String>();
        for (_local_1 in GroundLibrary.idToType_) {
            elements.push(_local_1);
        }
        elements.sort(MoreStringUtil.cmp);
        for each (_local_1 in elements) {
            _local_3 = GroundLibrary.idToType_[_local_1];
            _local_4 = new GroundElement(GroundLibrary.xmlLibrary_[_local_3]);
            addElement(_local_4);
            fullElements.push(_local_4);
        }
    }
    protected override function refresh(_arg_1:String):void{
        var _local_1:Element;
        if(_arg_1==""){
            for each(_local_1 in this.fullElements){
                addElement(_local_1);
            }
        }
        for each(_local_1 in this.elements_){
            try{this.elementSprite_.removeChild(_local_1);}catch(e){}
        }
        this.elements_ = new Vector.<Element>();
        var _local_2:String;
        for each (_local_2 in elements) {
            if(_arg_1=="" || _local_2.toLowerCase().search(_arg_1.toLowerCase())!=-1)addElement(new GroundElement(GroundLibrary.xmlLibrary_[GroundLibrary.idToType_[_local_2]]));
        }

    }

}
}//package com.company.assembleegameclient.mapeditor
