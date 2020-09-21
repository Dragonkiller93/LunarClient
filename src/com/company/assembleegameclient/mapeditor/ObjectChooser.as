package com.company.assembleegameclient.mapeditor {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.util.MoreStringUtil;

class ObjectChooser extends Chooser {
    private var fullElements:Vector.<Element> = new Vector.<Element>();
    private var elements:Vector.<String>;
    public function ObjectChooser() {
        var _local_1:String;
        var _local_3:int;
        var _local_4:XML;
        var _local_5:ObjectElement;
        super(Layer.OBJECT);
        elements = new Vector.<String>();
        for (_local_1 in ObjectLibrary.idToType_) {
            elements.push(_local_1);
        }
        elements.sort(MoreStringUtil.cmp);
        for each (_local_1 in elements) {
            _local_3 = ObjectLibrary.idToType_[_local_1];
            _local_4 = ObjectLibrary.xmlLibrary_[_local_3];
            if (!((((_local_4.hasOwnProperty("Item")) || (_local_4.hasOwnProperty("Player")))) || ((_local_4.Class == "Projectile")))) {
                _local_5 = new ObjectElement(_local_4);
                addElement(_local_5);
                fullElements.push(_local_5);
            }
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
            try{this.elementSprite_.removeChild(_local_1);}catch(e:Error){}
        }
        this.elements_ = new Vector.<Element>();
        var _local_2:String;
        var _local_3:int;
        var _local_4:XML;
        var _local_5:ObjectElement;
        for each (_local_2 in elements) {
            _local_3 = ObjectLibrary.idToType_[_local_2];
            _local_4 = ObjectLibrary.xmlLibrary_[_local_3];
            if ((_arg_1=="" || _local_2.toLowerCase().search(_arg_1.toLowerCase())!=-1) && !((((_local_4.hasOwnProperty("Item")) || (_local_4.hasOwnProperty("Player")))) || ((_local_4.Class == "Projectile")))) {
                _local_5 = new ObjectElement(_local_4);
                addElement(_local_5);
            }
        }
    }

}
}//package com.company.assembleegameclient.mapeditor
