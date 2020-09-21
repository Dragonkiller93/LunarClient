package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.engine3d.Face3D;
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Square;
import com.company.util.AssetLibrary;
import com.company.util.BitmapUtil;

import flash.display.BitmapData;
import flash.display.IGraphicsData;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.utils.StringUtil;

public class FullWall extends GameObject {

    private static const UVT:Vector.<Number> = new <Number>[0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0];
    private static const sqX:Vector.<int> = new <int>[0, 1, 0, -1];
    private static const sqY:Vector.<int> = new <int>[-1, 0, 1, 0];
    private var height:int =2;
    private var tileSize:int =8;
    private var wallTextures:Vector.<BitmapData> = new Vector.<BitmapData>();
    private var sideList:Vector.<int> = new Vector.<int>();
    public var faces_:Vector.<Face3D>;
    private var topFace_:Face3D = null;
    private var topTexture_:BitmapData = null;

    public function FullWall(_arg_1:XML) {
        this.faces_ = new Vector.<Face3D>();
        super(_arg_1);
        hasShadow_ = false;
        height = _arg_1.WallHeight;
        tileSize=_arg_1.TileSize;
        var _local_1:TextureData = ObjectLibrary.typeToTopTextureData_[objectType_];
        this.topTexture_ = _local_1.getTexture(0);

        var _local_2:XML;
        var _local_3:XML;

        for each(_local_3 in _arg_1.WallTextures) {
            var _local_5:int =0;
            var _local_4:BitmapData = new BitmapData(tileSize,tileSize*height);
            for each(_local_2 in _local_3.Texture) {
                var _local_6:BitmapData = AssetLibrary.getImageFromSet(_local_2.File, _local_2.Index);
                _local_4.copyPixels(_local_6, new Rectangle(0, 0, _local_6.width, _local_6.height), new Point(0, _local_5));
                _local_5 += _local_6.height;
            }
            var _local_7:int = height * tileSize;
            var _local_8:int;
            while ((_local_8 = (_local_7 - _local_5)) > 0) {
                var _local_9:int = Math.min(_local_8, _local_5);
                _local_4.copyPixels(_local_4, new Rectangle(0, 0, tileSize, _local_9), new Point(0, _local_5));
                _local_5 += _local_9;
            }
            wallTextures.push(_local_4);
        }
        var _local_10:String =  _arg_1.TextureList;
        _local_10.split(",");
        for each (var _local_11:String in _local_10.split(",") ){
            sideList.push(parseInt(StringUtil.trim(_local_11),10)-1);
        }
    }

    override public function setObjectId(_arg_1:int):void {
        super.setObjectId(_arg_1);
        var _local_2:TextureData = ObjectLibrary.typeToTopTextureData_[objectType_];
        this.topTexture_ = _local_2.getTexture(_arg_1);
    }

    override public function getColor():uint {
        return (BitmapUtil.mostCommonColor(this.topTexture_));
    }

    override public function draw(_arg_1:Vector.<IGraphicsData>, _arg_2:Camera, _arg_3:int):void {
        var _local_6:BitmapData;
        var _local_7:Face3D;
        var _local_8:Square;
        if (wallTextures[0] == null) {
            return;
        }
        if (this.faces_.length == 0) {
            this.rebuild3D();
        }
        var _local_4:BitmapData = wallTextures[0];
        if (animations_ != null) {
            _local_6 = animations_.getTexture(_arg_3);
            if (_local_6 != null) {
                _local_4 = _local_6;
            }
        }
        var _local_5:int;
        while (_local_5 < this.faces_.length) {
            _local_7 = this.faces_[_local_5];
            _local_8 = map_.lookupSquare((x_ + sqX[_local_5]), (y_ + sqY[_local_5]));
            if ((((((_local_8 == null)) || ((_local_8.texture_ == null)))) || (((((!((_local_8 == null))) && ((_local_8.obj_ is DoubleWall)))) && (!(_local_8.obj_.dead_)))))) {
                _local_7.blackOut_ = true;
            }
            else {
                _local_7.blackOut_ = false;
                if (animations_ != null) {
                    _local_7.setTexture(_local_4);
                }
            }
            _local_7.draw(_arg_1, _arg_2);
            _local_5++;
        }
        this.topFace_.draw(_arg_1, _arg_2);
    }

    public function rebuild3D():void {
        this.faces_.length = 0;
        var _local_1:int = x_;
        var _local_2:int = y_;
        var _local_3:Vector.<Number> = new <Number>[_local_1, _local_2, height, (_local_1 + 1), _local_2, height, (_local_1 + 1), (_local_2 + 1), height, _local_1, (_local_2 + 1), height];
        this.topFace_ = new Face3D(this.topTexture_, _local_3, UVT, false, true);
        this.topFace_.bitmapFill_.repeat = true;
        this.addWall(_local_1, _local_2, height, (_local_1 + 1), _local_2, height,sideList[0]);
        this.addWall((_local_1 + 1), _local_2, height, (_local_1 + 1), (_local_2 + 1), height,sideList[1]);
        this.addWall((_local_1 + 1), (_local_2 + 1), height ,_local_1, (_local_2 + 1), height,sideList[2]);
        this.addWall(_local_1, (_local_2 + 1), height, _local_1, _local_2, height,sideList[3]);
    }

    private function addWall(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number,_arg_7:int):void {
        var _local_7:Vector.<Number> = new <Number>[_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_4, _arg_5, (_arg_6 -height), _arg_1, _arg_2, (_arg_3 - height)];
        var _local_8:Face3D = new Face3D(wallTextures[_arg_7], _local_7, UVT, true, true);
        _local_8.bitmapFill_.repeat = true;
        this.faces_.push(_local_8);
    }


}
}//package com.company.assembleegameclient.objects
