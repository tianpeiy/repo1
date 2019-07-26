using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

using System.Net;
using System.Net.Sockets;

namespace luayundong
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                int port = 8811;
                string host = "127.0.0.1";
                //创建终结点EndPoint
                IPAddress ip = IPAddress.Parse(host);
                IPEndPoint ipe = new IPEndPoint(ip, port);//把ip和端口转化为IPEndPoint的实例

                //创建socket并连接到服务器
                Socket c = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                c.Connect(ipe);//连接到服务器
                //this.textBox2.Text = "connecting..." + "\r\n" + this.textBox2.Text;

                string sendStr = this.textBox1.Text;
                int a = 61 - Encoding.Default.GetByteCount(sendStr);
                if (a != 0)
                {
                    for (int i = 0; i < a; i++)
                    {
                        sendStr = sendStr + "0";
                    }
                }
               
                byte[] bs = Encoding.ASCII.GetBytes(sendStr);//把字符串编码为字节
                //this.textBox2.Text = "Send message" + "\r\n" + this.textBox2.Text;

                //Console.WriteLine("Send message");
                c.Send(bs, bs.Length, 0);//发送消息

                //接收从服务器接收返回的消息
                string recvStr = "";
                byte[] recvBytes = new byte[1024];
                int bytes;
                bytes = c.Receive(recvBytes, recvBytes.Length, 0);//从服务器端接收返回信息
                recvStr += Encoding.ASCII.GetString(recvBytes, 0, bytes);
                //Console.WriteLine("client get message:{0}", recvStr);//显示服务器返回信息
                this.textBox2.Text = recvStr + "\r\n" + this.textBox2.Text;

                //Console.ReadLine();
                c.Close();
            }
            catch (ArgumentException ex)
            {
                Console.WriteLine("argumentNullException(0)", ex);
            }
            catch (SocketException ex)
            {
                Console.WriteLine("SocketException:(0)", ex);
            }
        }
    }
}
