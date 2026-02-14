local returned_table,thread_id_not = ... 

thread_id = thread_id_not

require("love.timer")
require("love.window")

--love.window.showMessageBox("Info","Thread "..tostring(thread_id).." has been created.","info",true)

-- ^ idk why i added this..

require("libraries.scratchcode.main").comp_and_run(returned_table)

--love.window.showMessageBox("Info","Thread "..tostring(thread_id).." has ceased its operation.","info",true)\

-- ^ debugging stuff.