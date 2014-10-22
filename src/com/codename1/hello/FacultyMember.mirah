/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

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
    child:FacultyMember,
    children:FacultyMember[]
  
  
  def initialize
  end
  
  def initialize(name:String, age:int, weight:double)
    @name=name
    @age=age
    @weight=weight
  end
  
  
  
  

end

