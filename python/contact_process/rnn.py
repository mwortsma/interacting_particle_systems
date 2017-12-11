from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import tensorflow as tf
import numpy as np
import sys

def bool2int(a):
	a = np.array(a)
	return np.transpose([a.dot(1 << np.arange(a.shape[-1] - 1, -1, -1))])


embed_sz = 64
batch_sz = 2
window_sz = 1
hidden_sz = 64
output_sz = 5
input_sz = 3


inpt = tf.placeholder(tf.int32, shape=[batch_sz,window_sz])
targets = tf.placeholder(tf.int32, shape=[batch_sz, window_sz])
c_state = tf.placeholder(tf.float32, shape=[batch_sz, hidden_sz])
h_state = tf.placeholder(tf.float32, shape=[batch_sz, hidden_sz])


E = tf.Variable(tf.random_normal([2**input_sz, embed_sz], stddev=0.1))
print(E)
W = tf.Variable(tf.random_normal([hidden_sz, output_sz], stddev=0.1))
b = tf.Variable(tf.random_normal([output_sz], stddev=0.1))

embed = tf.nn.embedding_lookup(E, inpt)

rnn = tf.contrib.rnn.BasicLSTMCell(hidden_sz)
initial_state = rnn.zero_state(batch_sz, tf.float32)
output, next_state = tf.nn.dynamic_rnn(rnn, embed,initial_state=tf.contrib.rnn.LSTMStateTuple(c_state, h_state))

logits = tf.tensordot(output, W, [[2], [0]]) + b
probs = tf.sigmoid(logits)

#loss = tf.contrib.seq2seq.sequence_loss(logits,targets,tf.ones(shape=[batch_sz,window_sz]))


#train = tf.train.AdamOptimizer(0.001).minimize(loss)
sess = tf.Session()
sess.run(tf.global_variables_initializer())


#-------------------------------------------------
# print('training')
j = 0
st = sess.run(initial_state)
while j < 1:
	c,h = st
	log = sess.run([probs], 
		feed_dict={c_state:c, h_state:h, inpt:bool2int([[0, 0, 1], [1,1,0]])})
	j+=1
	print(log)



