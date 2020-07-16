package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput
public class ChangeSubclass extends OutgoingMessage{
    public var subclass_:int;
    public var feats_:Vector.<Boolean>;
        public function ChangeSubclass(_arg_1:int, _arg_2:Function) {
            this.feats_ = new Vector.<Boolean>();
            this.subclass_=0;
            super(_arg_1, _arg_2);
        }
    override public function writeToOutput(_arg_1:IDataOutput):void {
        _arg_1.writeShort(subclass_);
        var _local_2:int = 0;
        while (_local_2 < this.feats_.length) {
            _arg_1.writeBoolean(this.feats_[_local_2]);
            _local_2++;
        }
    }

    override public function toString():String {
        return (formatToString("CHANGESUBCLASS", "subclass_"));
    }

}
}
