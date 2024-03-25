object DMPadrao: TDMPadrao
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 221
  object AppEvents: TApplicationEvents
    OnException = AppEventsException
    Left = 24
    Top = 24
  end
end
