/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package ca.weblite.codename1.ws.macros
import mirah.lang.ast.*
import org.mirah.util.*



/**
 *
 * @author shannah
 */
class ExternalizableMacros 
  
  
  
  macro def self.attr_externalizable(version, objectId, fields:Hash)
    
    getVersion = quote do
      def getVersion:int 
        `version`
      end
    end
    
    getObjectId = quote do 
      def getObjectId:String
        `objectId`
      end
    end
    
    
    externalize = quote do
      def externalize(out:DataOutputStream):void
        
      end
    end
    
    internalize = quote do 
      def internalize(version:int, input:DataInputStream):void
        
      end
    end
    
    externalizeBody = NodeList.new
    fields.size.times do |i|
      e = fields.get i
      type = TypeName(e.value).typeref.name
      writeMethodName = if 'int'.equals type
        SimpleString.new 'writeInt'
      elsif 'boolean'.equals type
        SimpleString.new 'writeBoolean'
      elsif 'byte'.equals type
        SimpleString.new 'writeByte'
      elsif 'char'.equals type
        SimpleString.new 'writeChar'
      elsif 'double'.equals type
        SimpleString.new 'writeDouble'
      elsif 'float'.equals type
        SimpleString.new 'writeFloat'
      elsif 'long'.equals type
        SimpleString.new 'writeLong'
      elsif 'short'.equals type
        SimpleString.new 'writeShort'
      else
        nil
      end
      
      isArrayType=false
      if e.value.kind_of? TypeName
        isArrayType = TypeName(e.value).typeref.isArray
      end
      
      #writeMethodName = SimpleString.new 'writeInt'
      if writeMethodName 
        line = quote do
          out.`writeMethodName`(@`e.key`)
        end
      elsif 'String'.equals type
        line = quote do
          Util.writeUTF(@`e.key`, out)
        end
      else
        line = quote do 
          Util.writeObject(@`e.key`, out)
        end
      end
        
      externalizeBody.add line

    end
    
    internalizeBody = NodeList.new
    fields.size.times do |i|
      e = fields.get i
      type = TypeName(e.value).typeref.name
      
      readMethodName = if 'int'.equals type
        SimpleString.new 'readInt'
      elsif 'boolean'.equals type
        SimpleString.new 'readBoolean'
      elsif 'byte'.equals type
        SimpleString.new 'readByte'
      elsif 'char'.equals type
        SimpleString.new 'readChar'
      elsif 'double'.equals type
        SimpleString.new 'readDouble'
      elsif 'float'.equals type
        SimpleString.new 'readFloat'
      elsif 'long'.equals type
        SimpleString.new 'readLong'
      elsif 'short'.equals type
        SimpleString.new 'readShort'
      else
        nil
      end
      
      name = TypeName(e.key).typeref.name
      
      isArrayType=false
      if e.value.kind_of? TypeName
        isArrayType = TypeName(e.value).typeref.isArray
      end
      
      if readMethodName 
        line = quote do
          `"#{name}_set"` input.`readMethodName`
        end
      elsif isArrayType
        tmp = gensym
        line = quote do
          `tmp` = Object[].cast(Util.readObject(input))
          if `tmp` == nil
            `"#{name}_set"` nil
          else
            `"#{name}_set"` Arrays.asList(`tmp`).toArray(`type`[0])
          end
        end
      elsif 'String'.equals type
        line = quote do
          `"#{name}_set"` Util.readUTF(input)
        end
      else
        line = quote do
          `"#{name}_set"` `type`.class.cast(Util.readObject(input))
        end
      end
      internalizeBody.add line
    end
    
    externalize.body.add externalizeBody
    internalize.body.add internalizeBody
    
    out = NodeList.new
    out.add quote { import java.io.DataInputStream }
    out.add quote { import java.io.DataOutputStream }
    out.add quote { import com.codename1.io.Util }
    out.add quote { import java.util.Arrays }
    out.add getVersion
    out.add getObjectId
    out.add externalize
    out.add internalize
    
    args = [fields]
    out.add quote do
      attr_accessor `args`
    end
    
    out
  end
end

