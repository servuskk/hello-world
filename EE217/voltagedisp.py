#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np


# In[35]:


a=np.arange(256)


# In[37]:


v=a/255*33000


# In[41]:


v1=np.trunc(v/10000)
v1=v1.astype(int)


# In[45]:


v2=np.trunc((v%10000)/1000)
v2=v2.astype(int)


# In[49]:


v3=np.trunc((v%1000)/100)
v3=v3.astype(int)


# In[51]:


v4=np.trunc((v%100)/10)
v4=v4.astype(int)


# In[52]:


v5=np.trunc(v%10)
v5=v5.astype(int)


# In[72]:


with open("test.txt","w") as f:
    for i in range (256):
        f.write(str("when "+bin(a[i])+"=> v_33_1<="+str(v1[i])+"; v_33_2<="+str(v2[i])+"; v_33_3<="+str(v3[i])+"; v_33_4<="+str(v4[i])+"; v_33_5<="+str(v5[i])+";"+'\n'))

