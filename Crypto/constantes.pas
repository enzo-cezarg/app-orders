unit constantes;

{$mode Delphi}

interface

uses
  Classes, SysUtils;

const
  IP_LOCAL = 'localhost';
  IP_SERVER = '192.168.0.96';
  PORT = 3050;
  WIN_DATABASE = 'C:\Users\User\Desktop\Repositórios\AppPedidos\Database\APPORDERS.FDB';
  LIN_DATABASE = '/home/ello/databases/APPORDERS.fdb';
  LIN_LIBRARY_LOCATION = '/opt/firebird/lib/libfbclient.so.4.0.4';
  WIN_LIBRARY_LOCATION = 'C:\Program Files\Firebird\Firebird_4_0\fbclient.dll';
  PROTOCOL = 'firebird';
  USER = 'SYSDBA';
  PASSWORD = 'masterkey';

implementation

end.

