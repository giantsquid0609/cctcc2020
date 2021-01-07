public class GeneticAlgorithm {
  private int populationSize;

  
  private double mutationRate;

  private double crossoverRate;

  private int elitismCount;
  
  private int target[];
  
  public GeneticAlgorithm(int populationSize, double mutationRate, double crossoverRate, int elitismCount, int target[]) {
    this.populationSize = populationSize;
    this.mutationRate = mutationRate;
    this.crossoverRate = crossoverRate;
    this.elitismCount = elitismCount;
    this.target = target;
  }


  public Population initPopulation(int chromosomeLength) {
    Population population = new Population(this.populationSize, chromosomeLength);
    return population;
  }

  public double calcFitness(Individual individual) {

    int correctGenes = 0; // Number of correct genes
    int numOfOnes = 0;  // Number of ones

    // Loop over individual's genes
    for (int geneIndex = 0; geneIndex < individual.getChromosomeLength(); geneIndex++) {
      if(individual.getGene(geneIndex) == this.target[geneIndex]) {
        ++correctGenes;
      }
      if(individual.getGene(geneIndex) == 1){
        ++numOfOnes;
      }
    }

    double fitness = (double) correctGenes / individual.getChromosomeLength(); // Calculate fitness
    individual.setFitness(fitness);  // Store fitness
  
    // Calculate sharpness
    int sharpness;
    if(numOfOnes % 5 == 0){
      sharpness = 5;
    }else if(numOfOnes % 3 == 0){
      sharpness = 3;
    }else{
      sharpness = 0;
    }
    individual.setSharpness(sharpness); // Store sharpness
    
    return fitness;
  }

  public void evalPopulation(Population population) {
    double populationFitness = 0;

    for (Individual individual : population.getIndividuals()) {
      populationFitness += calcFitness(individual);
    }

    population.setPopulationFitness(populationFitness);
  }

  public boolean isTerminationConditionMet(Population population) {
    for (Individual individual : population.getIndividuals()) {
      if (individual.getFitness() == 1) {
        return true;
      }
    }

    return false;
  }

  public Individual selectParent(Population population) {

    Individual individuals[] = population.getIndividuals();

    double populationFitness = population.getPopulationFitness();
    double rouletteWheelPosition = Math.random() * populationFitness;

    double spinWheel = 0;
    for (Individual individual : individuals) {
      spinWheel += individual.getFitness();
      if (spinWheel >= rouletteWheelPosition) {
        return individual;
      }
    }
    return individuals[population.size() - 1];
  }

  public Population crossoverPopulation(Population population) {
    Population newPopulation = new Population(population.size());

    for (int populationIndex = 0; populationIndex < population.size(); populationIndex++) {
      Individual parent1 = population.getFittest(populationIndex);

      if (this.crossoverRate > Math.random() && populationIndex >= this.elitismCount) {
        Individual offspring = new Individual(parent1.getChromosomeLength());
        
        Individual parent2 = selectParent(population);

        for (int geneIndex = 0; geneIndex < parent1.getChromosomeLength(); geneIndex++) {
          if (0.5 > Math.random()) {
            offspring.setGene(geneIndex, parent1.getGene(geneIndex));
          } else {
            offspring.setGene(geneIndex, parent2.getGene(geneIndex));
          }
        }

        newPopulation.setIndividual(populationIndex, offspring);
      } else {
        newPopulation.setIndividual(populationIndex, parent1);
      }
    }

    return newPopulation;
  }

  public Population mutatePopulation(Population population) {
    Population newPopulation = new Population(this.populationSize);

    for (int populationIndex = 0; populationIndex < population.size(); populationIndex++) {
      Individual individual = population.getFittest(populationIndex);

      for (int geneIndex = 0; geneIndex < individual.getChromosomeLength(); geneIndex++) {
        if (populationIndex > this.elitismCount) {
          if (this.mutationRate > Math.random()) {
            int newGene = 1;
            if (individual.getGene(geneIndex) == 1) {
              newGene = 0;
            }
            individual.setGene(geneIndex, newGene);
          }
        }
      }

      newPopulation.setIndividual(populationIndex, individual);
    }

    return newPopulation;
  }

}
