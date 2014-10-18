#Mirah Macros for Codename One

This project includes macros that are helpful for Codename One projects.  The plan is to try to wrap as much common boiler-plate into macros so that developing Codename One apps will involve less typing.

Currently there is only one macro implemented:

`attr_externalizable` - A macro that allows you to generate Codename One classes that implement the `Externalizable` interface (i.e. can be persisted in Storage and used in web services).

##License

Apache 2.0

##Requirements

NetBeans with the [Codename One plugin](http://www.codenameone.com) and the [Mirah Plugin](https://github.com/shannah/mirah-nbm) installed.

##Installation in Codename One Projects

1. Download the latest [MirahMacrosForCN1-macros.jar](#foo) file.
2. Copy this jar file into the `lib/mirah/macros` directory of your Codename One project.

##Example Usage:

~~~
package ca.weblite.codename1.ws

import com.codename1.io.Externalizable

/**
 *
 * @author shannah
 */
class FacultyMember implements Externalizable
  
  
  attr_externalizable 1, 'FacultyMember',
    name:String,
    age:int, 
    weight:double,
    child:FacultyMember
  
  
  def initialize
  end
  
  def initialize(name:String, age:int, weight:double)
    @name=name
    @age=age
    @weight=weight
  end

end
~~~

**Key Points:**

1. The class must implement the [Externalizable](https://codenameone.googlecode.com/svn/trunk/CodenameOne/javadoc/com/codename1/io/Externalizable.html) interface.
2. The class must have a no-args constructor.
3. The `attr_externalizable` call automatically generates the methods required to fulfill the `Externalizable` interface.  It takes the following params.  The signature for this is as follows:

 ~~~
 def attr_externalizable(version:int, objectId:String, properties:Hash)
 ~~~

The equivalent Java implementation of this class would be:

~~~
package ca.weblite.codename1.ws;

import com.codename1.io.Externalizable;
import java.io.DataOutputStream;
import java.io.DataInputStream;
import com.codename1.io.Util;

/**
 *
 * @author shannah
 */
class FacultyMember implements Externalizable {
  
  private String name;
  private int age;
  private double weight;
  private FacultyMember child;
  
  public FacultyMember(){
  
  }
  
  public FacultyMember(String name, int age, double weight){
    this.name = name;
    this.age = age;
    this.weight = weight;
  }
  
  public String name(){ return name;}
  public int age(){ return age;}
  public double weight(){ return weight;}
  public FacultyMember child(){ return child;}
  
  public void name_set(String name){ this.name = name;}
  public void age_set(int age){ this.age = age;}
  public void weight_set(double weight){ this.weight = weight;}
  public void child_set(FacultyMember child){ this.child = child;}
  
  public int getVersion(){ return 1;}
  
  public String getObjectId(){ return "Faculty Member";}
  
  public void externalize(DataOutputStream out){
      Util.writeUTF(name);
      out.writeInt(age);
      out.writeDouble(weight);
      Util.writeObject(child);
  } 
  
  public void internalize(DataInputStream input){
    name = Util.readUTF(input);
    age = input.readInt();
    weight = input.readDouble();
    child = (FacultyMember)Util.readObject(input);
  }
  
  
  

~~~

##Credits

This project was created and is maintained by [Steve Hannah](http://sjhannah.com)