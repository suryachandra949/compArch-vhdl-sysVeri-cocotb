import numpy as np

def andf(A, B):
	return np.bitwise_and(np.int16(A),np.int16(B))


def orf(A, B):
	return np.bitwise_or(np.int16(A),np.int16(B))

def xorf(A, B):
	return np.bitwise_and(np.int16(A),np.int16(B))

def notf(A):
	return np.invert(np.int16(A))

def incf(A):
	return np.int16(A) + np.int16(1)

def decf(A):
	return np.int16(A) - np.int16(1)

def addf(A,B):
	return np.int16(A) + np.int16(B)
def subf(A,B):
	return np.int16(A) - np.int16(B)

def sh_left(A,X):
	return np.left_shift(np.int16(A),np.int16(X))

def sh_right(A,X):
	return np.right_shift(np.int(A),np.int16(X))







def alu_model(A, B, X, OPCODE):

	
	switcher={
		4: andf(A,B),
		5: orf(A,B),
		6: xorf(A,B),
		7:notf(A),
		8: incf(A),
		9: decf(A),
		10: addf(A,B),
		11: subf(A,B),
		12: sh_left(A,X),
		13: sh_right(A,X)

	}

	return int(switcher.get(OPCODE,np.int16(A)))
