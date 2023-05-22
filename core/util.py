import matplotlib.pyplot as plt
import numpy as np
import random as rand
from sklearn import preprocessing


def fit_standardizer(data, standardizer, flattened=False):
    if flattened:
        data_flat = data
    else:
        n_traj, traj_length, n = data.shape
        data_flat = data.T.reshape((n, n_traj * traj_length), order='F').T

    standardizer.fit(data_flat)

    return standardizer

def split_dataset(x_test, u_test, t_test, dataset_length):
    x_tests, u_tests, t_tests = [], [], []
    for x, u, t in zip(x_test, u_test, t_test):
        cur_index = 0
        while cur_index+dataset_length < t.shape[0]:
            x_tests.append(x[cur_index:cur_index+dataset_length, :])
            u_tests.append(u[cur_index:cur_index + dataset_length-1, :])
            t_tests.append(t[cur_index:cur_index + dataset_length] - t[cur_index])
            cur_index += dataset_length

    return np.array(x_tests), np.array(u_tests), np.array(t_tests)



