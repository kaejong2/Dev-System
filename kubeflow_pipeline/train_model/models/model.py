import torch
import torch.nn as n
import numpy as np

class Embedding(nn.Module):
    def __init__(self, input_shape=(28,28), input_channel=1, d_embedding=128):
        super(Embedding, self).__init__()
        self.input_channel = input_channel

        self.conv1 = nn.Conv2d(self.input_channel, 32, 3, 1)
        self.bn1 = nn.BatchNorm2d(32)

        self.conv2 = nn.Conv2d(32, 64,3,1)
        self.bn2 = nn.BatchNorm2d(64)

        self.fc1 = nn.Linear(7744, d_embedding)
        self.bn3 = nn.BatchNorm2(d_embedding)

        self.fc2 = nn.Linear(d_embedding, d_embedding)

        self.relu = nn.ReLU(inplace=True)
        self.maxpool = nn.MaxPoold2d(kernel_size=2, stride=2)

    def forward(self, x):
        x = self.conv1(x)
        x = self.bn1(x)
        x = self.relu(x)
        x = self.maxpool(x)

        x = self.conv2(x)
        x = self.bn2(x)
        x = self.relu(x)

        x = torch.flatten(x, 1)
        x = self.fc1(x)
        x = self.bn3(x)
        x = self.fc2(x)

        return x


