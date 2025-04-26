extends Node


class_name GameboardItem

## CLASS OVERVIEW
#Level of Detail
#Path information (including info on is it for Pedestrian or Car
#Elevation (swap between items with variable elevations)
#item variations, such as road vs joint (Decision road, joint, bridge will all be unique gameboard items and not like swap between them as if they were the same

#oriented_size

##how is it going to be created: Road2Lane.new(), this has nothing to do with picking what thing to create
##THIS WILL NOT DEAL WITH, oh the xyz button was pressed and based on that what item needs to be created, that will be handeld elsewhere

##to make accurate placment easier I will often have items Tiled, such as the curtains for parking, allowing me to easily place them where i want in figma
##other items such as walkways do not get this treatment, becuase I will be moving them around in the gameworld, and I want to easily get their size (so I can clip to custom grid) without having to adjust for the extra border padding.

#what is the type
#make it easy to see its attachments
#move
#level, upgrade


#ingress and egress for cars and humans
##Transform
