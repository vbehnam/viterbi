
# Parameters: emission matrix, an M x N matrix, where emission[j, k] is the probability of observing state k from hidden state j
# transition matrix, an N x N matrix, with transition[j, k] showing the probability of transitioning from state k to state j
# initial is a N x 1 vector of initial probabilities for hidden states. i.e. the p(x=i) at time t=1
# observations is a L x 1 vector of observations

# Output: An L x 1 vector of the most likely hidden state sequence

viterbi <- function(emission, transition, initial, observations) {
  
  # helper method that checks if the inputs are valid. if not, it returns an error message
  checkInputs(emission, transition, initial, observations)

  numStates <- nrow(transition)
  
  numObs <- length(observations)
  
  # initialize the two matrices, stateSeq will store the most likely states up until this point, while prob state
  # is the corresponding likelihood
  probSeq <- matrix(data=0, nrow=numStates, ncol=numObs)
  
  stateSeq <- matrix(data=0, nrow=numStates, ncol=numObs)
  
  firstObs <- observations[1]
  
  # fill in first columns of both matrices
       
  probSeq[,1] <- initial[]*emission[,firstObs]
    
  stateSeq[,1] <- 0
  
  
  for (i in 2:numObs) {
    
    for (j in 1:numStates) {
      
      obs <- observations[i]
      
      # initialize this value to -1. This will be overwritten immediately by the for loop since all possible values are >= 0
      probSeq[j,i] <- -1
      
      # the point of this for loop is to find the max and argmax for k
      for (k in 1:numStates) {
        
        value <- probSeq[k, i-1]*transition[k,j]*emission[j,obs]
        
        if (value > probSeq[j,i]) {
          
          # maximizing for k
          probSeq[j,i] <- value
          
          # argmaximizing for k
          stateSeq[j,i] <- k
          
        }
      }
    }
  }
  
  # MLP = most likely path
  MLP <- numeric(numObs)
  
  # argmax for the stateSeq[,numObs]
  am <- which.max(probSeq[,numObs])

  MLP[numObs] <- stateSeq[am,numObs]

  # we backtrace using backpointers
  for (i in numObs:2) {
    
    zm <- which.max(probSeq[,i])
    
    MLP[i-1] <- stateSeq[zm,i]
    
  }

  return(MLP)
  
}


# helper method that checks if inputs are valid. If any of the inputs are invalid, an error message is thrown.
checkInputs <- function(emission, transition, initial, observations){
  
  numStates <- nrow(transition)
  
  # checks if the dimensions of the matrices line up
  if (nrow(emission) != numStates) {
    stop("the dimensions of the emission matrix and transition matrix don't line up!")
  }
  
  if (nrow(transition) != ncol(transition)) {
    stop("the transition matrix is not square!")
  }
  
  if (length(initial) != numStates) {
    stop("the length of the initial vector of probabilities is not equal to the number of states in the transition matrix!")
  }
  
  # checks if the vectors are actually vectors
  if (is.vector(initial) != TRUE || is.vector(observations) != TRUE) {
    stop("one of the vectors is not actually a vector!")  
  }
  
  # the next three check if probabilities sum up to 1
  
  if (sum(initial) != 1) {
    stop("the initial vector does not sum up to 1!")
  }
  
  for (i in 1:numStates) {
    if (sum(emission[i,]) != 1) {
      stop("one or more of the rows of the emission matrix do not sum to 1!")
    }
  }
  
  for (i in 1:numStates) {
    if (sum(transition[i,]) != 1) {
      stop("one or more of the rows of the transition matrix do not sum to 1!")
    }
  }
  
}
