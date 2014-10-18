

package ca.weblite.codename1.ws.macros

/**
 *
 * @author shannah
 */
class Bootstrap 
  macro def self.loadExtensions
    @mirah.type_system.extendClass("java.lang.Object", ExternalizableMacros.class)
    nil
  end
end

