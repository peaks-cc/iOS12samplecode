import keras
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense, Dropout
from keras.optimizers import RMSprop
from keras.layers import Conv2D, MaxPooling2D
from keras.layers import Activation, AveragePooling2D, Conv2D, Flatten
from keras.layers import Lambda
from keras import backend as K # tensorflow

import numpy as np

import coremltools
from coremltools.proto import NeuralNetwork_pb2

import os

kears_file = "./KerasMNIST_customlayer.h5"
coreml_file = './KerasMNIST_customlayer.mlmodel'

# Just relu
def custom_relu_activation(x):
    return K.relu(x)

    def build_and_learn_keras_model():


    batch_size = 128
    num_classes = 10
    epochs = 7

    # the data, shuffled and split between train and test sets
    (x_train, y_train), (x_test, y_test) = mnist.load_data()

    print(x_train.shape)
    print(x_train.shape[1:])

    img_rows = 28
    img_cols = 28

    x_train = x_train.reshape(x_train.shape[0], img_rows, img_cols, 1)
    x_test = x_test.reshape(x_test.shape[0], img_rows, img_cols, 1)
    input_shape = (img_rows, img_cols, 1)

    x_train = x_train.astype('float32')
    x_test = x_test.astype('float32')

    # 入力値の正規化
    x_train /= 255
    x_test /= 255

    # 教師データをクラス分類のデータに変換
    y_train = keras.utils.to_categorical(y_train, num_classes)
    y_test = keras.utils.to_categorical(y_test, num_classes)

    print(x_train.shape[0], 'train samples')
    print(x_test.shape[0], 'test samples')

    # ネットワーク設計
    model = Sequential()
    model.add(Conv2D(32, kernel_size=[6, 6], padding='same', input_shape=input_shape))

    # custom layer
    model.add(Lambda(custom_relu_activation))

    model.add(Conv2D(32, kernel_size=[6, 6], padding='same', input_shape=input_shape))
    model.add(Activation('relu'))
    model.add(Conv2D(32, kernel_size=[3, 3], padding='same', input_shape=input_shape))
    model.add(Activation('relu'))
    model.add(Conv2D(32, kernel_size=[3, 3], padding='same', activation='relu'))
    model.add(Flatten())
    model.add(Dense(128))
    model.add(Activation('relu'))

    model.add(Dense(num_classes, activation='softmax'))

    # ネットワークの構成を出力する
    model.summary()

    model.compile(loss='categorical_crossentropy',
                  optimizer=RMSprop(),
                  metrics=['accuracy'])

    history = model.fit(x_train, y_train,
                        batch_size=batch_size,
                        epochs=epochs,
                        verbose=1,
                        validation_data=(x_test, y_test))
    score = model.evaluate(x_test, y_test, verbose=0)
    print('Test loss:', score[0])
    print('Test accuracy:', score[1])

    return model

if not os.path.exists(kears_file):
    keras_model = build_and_learn_keras_model()
    keras_model.save(kears_file)

def convert_custom_lambda_layer(layer):

    params = NeuralNetwork_pb2.CustomLayerParams()

    if layer.function.__name__ == custom_relu_activation.__name__:
        # カスタムレイヤーに割り当てるクラス
        params.className = "MyCustomReluActivation"
        # Xcodeで表示される解説文
        params.description = "RELU"

        # その他のパラメタ
        params.parameters["test"].stringValue = "hoge"
        params.parameters["param"].intValue = 10

        # 重みを設定・・・ReLUには無関係
        my_weights = params.weights.add()
        my_weights.floatValue.extend(np.zeros(10).astype(float))
        my_weights.floatValue[0] = 3
        my_weights.floatValue[1] = 1
        my_weights.floatValue[2] = 4
        my_weights.floatValue[3] = 1
        my_weights.floatValue[4] = 5
        my_weights.floatValue[5] = 9
        my_weights.floatValue[6] = 2
        my_weights.floatValue[7] = 6
        my_weights.floatValue[8] = 5
        my_weights.floatValue[9] = 3

        return params
    elif layer.function.__name__ == custom_sigmoid_activation.__name__:

        # Lambdaレイヤーをいくつか使う場合は，関数名などで分岐する

        params.className = "MyCustomSigmoidActivation"
        params.description = "sigmoid"
        return params
    else:
        return None

coreml_model = coremltools.converters.keras.convert(
    kears_file,
    input_names='image',
    output_names='digit',
    add_custom_layers=True,
    custom_conversion_functions={ "Lambda": convert_custom_lambda_layer }
)

coreml_model.author = u'Yuichi Yoshida'
coreml_model.license = 'MIT'
coreml_model.short_description = u'Custom layerのサンプル．'

coreml_model.input_description['image'] = u'入力画像'
coreml_model.output_description['digit'] = u'推定した数字の確率'

coreml_model.save(coreml_file)

# Look at the layers in the converted Core ML model.
print("\nLayers in the converted model:")
for i, layer in enumerate(coreml_model._spec.neuralNetwork.layers):
    if layer.HasField("custom"):
        print("Layer %d = %s --> custom layer = %s" % (i, layer.name, layer.custom.className))
    else:
        print("Layer %d = %s" % (i, layer.name))
