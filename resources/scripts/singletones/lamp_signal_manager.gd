#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#lamp_signal_manager.gd
#global singletone for signal manager
#################################
extends Node

#GridWidget
signal widget_input(event, widget_cursor)

#WorkspaceBaseBody
signal body_input(res_properties, id)
signal data_changed(new_data, property_name, value_type, id)

#WorkspaceUI
signal play()
signal pause()
