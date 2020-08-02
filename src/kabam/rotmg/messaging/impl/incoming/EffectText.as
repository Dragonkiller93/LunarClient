package kabam.rotmg.messaging.impl.incoming {
import flash.utils.ByteArray;
import flash.utils.IDataInput;

public class EffectText extends IncomingMessage {

    public var message_:String;

    public function EffectText(_arg_1:uint, _arg_2:Function) {
        super(_arg_1, _arg_2);
    }

    override public function parseFromInput(_arg_1:IDataInput):void {
        this.message_=_arg_1.readUTF();
    }

    override public function toString():String {
        return (formatToString("EFFECTTEXT", "message_"));
    }


}
}//package kabam.rotmg.messaging.impl.incoming
