/***
* Name: TyphoonEvacuationGrid
* Author: reyrodrigueza
* Description: An initail model of typhoon evacuation behavior using grid
* Tags: Tag1, Tag2, TagN
***/

model TyphoonEvacuationGrid

/* Insert your model definition here 
 * */

global {
	int nb_rescuers_init <- 1;			//initial number of rescuers
	int nb_households_init <- 5;		//initial number of households
	int nb_houses_init <- 20;			//initial number of houses
	int nb_shelterManagers_init <- 2;	//initial number of shelter managers
	

	init {
		create rescuers number: nb_rescuers_init ;		
		create households number: nb_households_init;	
		create houses number: nb_houses_init ;	
		create shelterManagers number: nb_shelterManagers_init;		
	}
}

species rescuers {
	float size <- 0.8 ;
	rgb color <- rgb(141,211,199);
	neighborhood_cell myCell <- (1,2); //one_of (neighborhood_cell) ;
		
	init {
		location <- myCell.location;
	}
		
	aspect base {
		draw circle(size) color: color ;
		//draw circle(size*20) color: #orange empty: true;
	}
}

species households {
	float size <- 1.0 ;
	rgb color <- rgb(255,255,179);
	neighborhood_cell myCell <- one_of (neighborhood_cell) ;
		
	init {
		location <- myCell.location;
	}
		
	aspect base {
		draw circle(size*15) color: #orange empty: true; //perception distance
		draw square(size*5) color: rgb(190,186,218) ; 	 //household
		draw square(size) color: color ; 				 //house
	}
}

species shelterManagers {
	float size <- 1.0 ;
	rgb color <- rgb(255,255,179);
	neighborhood_cell myCell <- one_of (neighborhood_cell) ;
		
	init {
		location <- myCell.location;
	}
		
	aspect base {
		//draw circle(size*15) color: #orange empty: true; //perception distance
		draw square(size*8) color: rgb(179,0,0) ; 		   //shelter
		draw square(size) color: color ; 				   //shelter manager
	}
}

species houses {
	float size <- 5.0;
	rgb color <- rgb(190,186,218);
	neighborhood_cell myCell <- one_of(neighborhood_cell);
	
	
	init {
		//any_location_in(one_of(building));
		location <- myCell.location;
	}
	
	aspect base {
		draw square(size) color: color ;
	}
}

grid neighborhood_cell width: 60 height: 60 neighbors: 4 {
	rgb color <- rgb(251,128,114);
	
	//float maxSoil <- 1.0 ;
	//float soilProd <- (rnd(1000) / 1000) * 0.01 ;
	//float soil <- (rnd(1000) / 1000) max: maxSoil update: soil + soilProd ;
	//rgb color <- rgb(int(255 * (1 - food)), 255, int(255 * (1 - food))) update: rgb(int(255 * (1 - food)), 255, int(255 *(1 - food))) 
	//rgb color <- rgb(255, int(255 * (1 - soil)), int(255 * (1 - soil))) update: rgb(255, int(255 * (1 - soil)), int(255 * (1 - soil)));
}

experiment typhoon_evacuation_behavior type: gui {
	parameter "Initial number of Rescuers: 	 " var: nb_rescuers_init   min: 1 max: 20 category: "Rescuers" ;
	parameter "Initial number of Households: " var: nb_households_init min: 3 max: 50 category: "Households" ;
	//parameter "Initial number of Houses: " var: nb_houses_init min: 5 max: 100 category: "Houses" ;
	parameter "Initial number of Shelter Managers: " var: nb_shelterManagers_init min: 2 max: 5 category: "Shelter Managers" ;
	
	
	output {
		display main_display {
			grid neighborhood_cell lines: #black ;
			species rescuers aspect: base ;
			species households aspect: base ;
			species shelterManagers aspect: base;
		}
		display info_display {
			grid neighborhood_cell lines: #black ;
			species rescuers aspect: base ;
			species households aspect: base ;
			species shelterManagers aspect: base;
		}
		//monitor "Number of Households" value: nb_rescuers_init;
		//monitor "Number of Rescuers" value: nb_households_init;
		//monitor "Number of Shelter Managers" value: nb_shelterManagers_init;
		
	}
}

 