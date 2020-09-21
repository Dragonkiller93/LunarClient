package com.company.assembleegameclient.mapeditor {
import com.company.assembleegameclient.map.RegionLibrary;

public class RegionChooser extends Chooser {
    public function RegionChooser() {
        var _local_1:XML;
        var _local_2:RegionElement;
        super(Layer.REGION);
        for each (_local_1 in RegionLibrary.xmlLibrary_) {
            _local_2 = new RegionElement(_local_1);
            addElement(_local_2);
        }
    }
    protected override function refresh(_arg_1:String):void{
        var _local_1:Element;
        for each(_local_1 in this.elements_){
            try{this.elementSprite_.removeChild(_local_1);}catch(e){}
        }
        this.elements_ = new Vector.<Element>();
        var _local_2:RegionElement;
        var _local_3:XML;
        for each (_local_3 in RegionLibrary.xmlLibrary_) {
            if(_arg_1=="" || String(_local_3.@id).toLowerCase().search(_arg_1.toLowerCase())!=-1) {
                _local_2 = new RegionElement(_local_3);
                addElement(_local_2);
            }
        }
    }
}
}//package com.company.assembleegameclient.mapeditor
