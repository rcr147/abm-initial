/***
* Name: TyphoonEvacuationGrid
* Author: reyrodrigueza
* Description: An initail model of typhoon evacuation behavior using grid
* Tags: Tag1, Tag2, TagN
***/

model TyphoonEvacuationModel

/* Insert your model definition here 
 * */

global {
	int nb_rescuers_init <- 5;			//initial number of rescuers
	int nb_households_init <- 10;		//initial number of households
	int nb_houses_init <- 20;			//initial number of houses
	int nb_shelterManagers_init <- 2;	//initial number of shelter managers
	
	float floodHeight_init <- 0.0;
	float floodWaterFlowSpeed <- 0.0;
	float stormIntensity <- 0.0;
	float rainfallIntensity <- 0.0;
	float tideLevel <- 0.0;
	
	date catastrophe_date;
	float time_before_hazard <- 1#h ;
	bool stay <- true;
	
	file road_file <- file("../includes/roads.shp");
	file buildings <- file("../includes/buildings.shp");
	file water_body <- file("../includes/waterways.shp");
	
	geometry shape <- envelope(envelope(road_file)+envelope(water_body));
//	
	graph<geometry, geometry> road_network;
	map<road,float> road_weights;
//	
	int xbounds <- int(shape.width/10); 
	int ybounds <- int(shape.height/10); 
	int xmin <- xbounds;   
	int ymin <- ybounds;  
	int xmax <- int(shape.width - xbounds);     
	int ymax <- int(shape.height - ybounds);

	init 
	{
		create road from:road_file;
		create building from:buildings;
		create hazard from: water_body;
		
		create households number:nb_households_init {
			location <- any_location_in(one_of(building));
//			safety_point <- evacuation_point with_min_of (each distance_to self);
		}		
		
		create rescuers number:nb_rescuers_init
		{
			location <- any_location_in(one_of(building));
//			evacuation_point start <- any_location_in(one_of(building));
//			location <-start.location;
//			capacity <- nb_capacity;
//			home <- start;
		}
		
		create shelterManagers number:nb_shelterManagers_init
		{
			location <- any_location_in(one_of(building));
		}		
		
		road_network <- as_edge_graph(road);
		road_weights <- road as_map (each::each.shape.perimeter);
		
//		create MDRRMO;
		
	}
}


species households skills:[moving] {
	float vitality <- 0.0;
	float perceivedRisk <- 0.0;
	float headOfHousehold <- 0.0;
	float levelOfEducation <- 0.0;
	float hasSmallKids <- 0.0;
	float hasElderly <- 0.0;
	float withDisability <- 0.0;
	float houseRented <- 0.0;
	float yearsOfResidency <- 0.0;
	float pastTyphoonExperience <- 0.0;
	float stormSeverity <- 0.0;
	float rainfallSeverity <- 0.0;
	float proximityToHazard <- 0.0;
	float sourceOfTyphoonInformation <- 0.0;
	float sourceOfEvacuationWarning <- 0.0;
	int totalNeighborhood <- 0;
	
	//households<list> neighborhood <- null;
	float houseQuality <- 0.0;
	float floorLevels <- 0.0;
	float houseDamage <- 0.0;
	
	//Graph roadNetwork
	float priority;
	float size;
	
	rgb color <- rgb(255,255,179);
	
	reflex calculate_priority 
	{
		priority <- self.location distance_to hazard[0];
	}
	
	aspect default 
	{	
		draw circle(2#m) color:stay ? #red : #yellow;
//		draw circle(50#m) color: #cyan empty: true; //perception distance
	}
	
	//BEHAVIORS ******************
	//computeVitality()
	//computeRiskPerceived()
	//askForHelp()
	//evacuate()
	//helpNeighbor()
	//cooperate()
	//defect()
	//countNeighbors()
	//die()
}


species rescuers skills:[moving] {
	int capacity <- 0;
	int sensedHouseholds <- 0;
	int sensedFellowRescuers <- 0;
	float proximityToHazard <- 0.0;
	float vitality <- 0.0;
	float perceivedRisk <- 0.0;
	float severityOfStorm <- 0.0;
	float severityOfRainfall <- 0.0;	
	
	float size <- 0.8 ;
	rgb color <- rgb(141,211,199);
		
	aspect default {
//		if(load>=capacity)	{	draw triangle(10#m) color:#black;	}
//		else				{	draw triangle(10#m) color:#green;	}
		draw circle(2#m) color:#green;
//		draw circle(50#m) color: #orange empty: true;	//perception distance
	}
	
	//BEHAVIORS *********************
	//reflex compute riskPerceived(){}
	//fetchHousehold()
	//goToAssignedPost()
	//goToEvacuationCenter()
	//helpFellowRescuer()
	//reportToMDRRMO()
	//computeVitality()
	//computePerceivedRisk()
	//die()
	
	
//	households calculate_priority(list<households> a, float p){
//		households result;
//		int idx;
//		float maxval <-0.0;
//		float val<-0.0;
//		
//		loop obs over: a {
//			float x <- obs distance_to self;
//			float y <- obs distance_to first(hazard);		
//			val <- 1/((x)^p*(y)^(1-p));
//			
//			if(val>maxval){
//				maxval<-val;
//				result<-obs;
//			}
//		}
//		return result;	
//	}
//	
//	action bounding {
//	
//			if  (location.x) < xmin {
//				velocity <- velocity + {xbounds,0};
//			} else if (location.x) > xmax {
//				velocity <- velocity - {xbounds,0};
//			}
//			
//			if (location.y) < ymin {
//				velocity <- velocity + {0,ybounds};
//			} else if (location.y) > ymax {
//				velocity <- velocity - {0,ybounds};
//			}
//			
//		
//	}

}

species shelterManagers 
{
	int capacity <- 0;
	
	float size <- 1.0 ;
	rgb color <- rgb(255,255,179);
		
	aspect default 
	{
		draw circle(2#m) color:#blue;
//		draw circle(50#m) color: #purple empty: true;	//perception distance
	}
	
	//BEHAVIORS *************
	//countEvacuees()
	//checkCapacity()
	//disallowEntry()
}

species building 
{
	aspect default 
	{
		draw shape color: #gray border: #black;
	}
}

species hazard {
	
	
	float speed <- 5#m/#mn;
	
	init {
		catastrophe_date <- current_date + time_before_hazard;
	}
	
//	reflex expand when:catastrophe_date < current_date {
//		shape <- shape buffer (speed);
//		ask households overlapping self {
//			if(self.stay=true){
//					casualties <- casualties + 1; 
//			}
//					
//			self.assigned_rescuer.target <- nil;
//			do die;
//		}
//		
//		ask evacuation_point where (each distance_to self < 2#m) {
//			list<evacuation_point> available_exit <- evacuation_point where (each != self);
//			ask households where (each.safety_point = self) {
//				self.safety_point <- available_exit with_min_of (each distance_to self);
//			}
//			do die;
//		} 
//	}
	
//	aspect default {
//		draw shape color:#blue;
//	}
	
}



species road 
{
	int users;
	int capacity <- int(shape.perimeter*8);
	float speed_coeff <- 1.0;
	
	reflex update_weights 
	{
		speed_coeff <- exp(-users/capacity);
		road_weights[self] <- shape.perimeter / speed_coeff;
		users <- 0;
	}
	
	aspect default
	{
		draw shape width: 4#m-(3*speed_coeff)#m color:rgb(55+200*users/capacity,0,0);
	}	
	
 	aspect dummy_1 
 	{
		draw shape rotated_by(90) width: 4#m-(3*speed_coeff)#m color:rgb(55+200*users/capacity,0,0);
	}
}

species evacuation_point 
{
	int count_exit <- 0;
	
	action evacue_inhabitant 
	{
		count_exit <- count_exit + 1;
	}
}



experiment typhoon_evacuation_behavior type: gui 
{
	parameter "Number of Households: " var: nb_households_init min: 10 max: 1007 category: "Agents" ;
	parameter "Number of Rescuers: 	 " var: nb_rescuers_init   min: 5 max: 20 category: "Agents" ;
	parameter "Number of Shelter Managers: " var: nb_shelterManagers_init min: 2 max: 5 category: "Agents" ;
	
	parameter "Time before hazard" var:time_before_hazard init:1#h min:5#mn max:2#h;
	
	output 
	{
		display main_display type:opengl 
		{ 
			species road;
			species evacuation_point;
			species hazard;
			species building;
			species households;
			species rescuers;
			species shelterManagers;
		}
		
		display info_display type:opengl 
		{ 
			species road;
			species evacuation_point;
			species hazard;
			species building;
			species households;
			species rescuers;
			species shelterManagers;
		}
						
//		monitor "Number of Households" value: nb_households_init ;
//		monitor "Number of Rescuers" value: nb_rescuers_init ;
//		monitor "Number of Shelter Managers" value: nb_shelterManagers_init;
//		
	}
}

 