function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

%% Forward prop
%Input
A1 = [ones(m, 1) X];

%Hidden1
Z2 = A1 * Theta1';
A2 = [ones(m, 1), sigmoid(Z2)];

%Output
Z3 = A2 * Theta2';
A3 = sigmoid(Z3);




%% Cost
%--Compute y to Y (binary form)
Y = zeros(length(y), num_labels);

%Taking Y as a long vector and Acquire the index
idx = sub2ind(size(Y), 1:m, y');

%Assign 1 to proper locations
Y(idx) = 1;


%--Compute the cost J
%Unregularized
J = (1 / m) * sum(sum((-Y) .* log(A3) - (1 - Y) .* log(1 - A3)));

%Regularization term
reg = (lambda / (2 * m)) * (sum(sum(Theta1(:, 2:end) .* Theta1(:, 2:end))) + sum(sum(Theta2(:, 2:end) .* Theta2(:, 2:end))));

%Final cost
J = J + reg;




%% Back prop
%Output
d3 = A3 - Y;
D2 = d3' * A2;

%Hidden
d2 = d3 * Theta2(:, 2:end) .* sigmoidGradient(Z2);
D1 = d2' * A1;

%Gradient (unregularized)
Theta2_grad = D2 / m;
Theta1_grad = D1 / m;

%Regularization term
reg2 = (lambda / m) * Theta2;
reg1 = (lambda / m) * Theta1;
reg2(:, 1) = 0; reg1(:, 1) = 0;

%Gradient (regularized)
Theta2_grad = Theta2_grad + reg2;
Theta1_grad = Theta1_grad + reg1;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
