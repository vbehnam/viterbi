# viterbi

Given a hidden markov model with a transition matrix, an emission matrix and a vector of initial probabilities at time t=1, and a vector of observations, this algorithm uses dynamic programming to find the likeliest chain of hidden states.

The algorithm has a helper method that checks for invalid inputs, such as incongruent matrix dimensions, or rows that don't sum to one, and returns an error message for each one. (in other words, a get-out-of-jail-card for all you sloppy inputters!)

This implementation only works with discrete & finite transition matrices, emission matrices and vector of initial probabilities.
