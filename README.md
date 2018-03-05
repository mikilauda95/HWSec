# Hardware Security: An evolutionary mitigation for Trojan-Horse attacks

Due to the increasing costs of manufacturing chips with smaller and smaller transistors, the vast majority of companies is forced to employ and trust a third party to fabricate their design.  
This makes them very susceptible to malicious circuitry injected into their chip at fabrication time. We want to focus on digital hardware that can cause unintended behavior: e.g. a trojan.  
The project is divided into two parts: understanding how a digital hardware trojan works by developing an example, and how to mitigate or deny its malicious effects.

The *__Report.pdf__* file aims at gathering the result of applying an evolutionary algorithm to some assembly programs (study cases) in a miniMIPS environment, in order to avoid the activation of an hardware trojan inside it.

Project developed for the courses of _Computer Architectures_ and _Specification and Simulation of Digital Systems_ at Politecnico di Torino, year 2016-2017.

Here is a short presentation video is available here:

https://www.youtube.com/watch?v=jyF__vjLnX0


### Prerequisites

+ ModelSim Altera to run simulations
+ MicroGP (info and installation can be found here https://sourceforge.net/p/ugp3/wiki/Home/)
+ MiniMIPS source code and assembler


### Simulation

After navigating to the *FinalWork/Working_folder* directory, the flow can be started by running the *uGP* command.  

In the *hwsec.constraints.xml* file you can find parameters that define each single individual, how its genes are represented, and how many there are.  
In the *hwsec.population.settings.xml* file you can find parameters for the population. For example, you can set stop conditions (e.g. fitness threshold, number of stable generations, timeout) and evolutionary parameter that affect the mathematical behavior of the simulation.  
In the *fitness* directory, the *startingCode.src* file holds the source code of the initial assembly program, that will be mutated according to each individual's genes.

uGP will generate a random starting population, then run the *hwsec.fitness-script.sh* script to compute a fitness value for each individual. The program will then call other programs such as python scripts that parse the genes and apply their effects and the ModelSim simulation.   
When all fitness values are computed, uGP takes control again and continues by creating the next generation by eliminating the least fit individuals, and creating new ones from the offspring of the survivors.

After a stop condition is reached, uGP will create some .csv files that hold information about all past generations, their fittest individual for each and much more data. The *cleanup.sh* script deletes all temporary files and data from the last simulation, allowing for a fresh restart.
