INSERT INTO [guest].[department]([dept_name], [building], [budget]) VALUES ('Biology', 'Watson', 90000);
INSERT INTO [guest].[department]([dept_name], [building], [budget]) VALUES ('Comp.Sci.', 'Taylor', 100000);
INSERT INTO [guest].[department]([dept_name], [building], [budget]) VALUES ('Elec.Eng.', 'Taylor', 85000);
INSERT INTO [guest].[department]([dept_name], [building], [budget]) VALUES ('Finance', 'Painter', 120000);
INSERT INTO [guest].[department]([dept_name], [building], [budget]) VALUES ('History', 'Painter', 50000);
INSERT INTO [guest].[department]([dept_name], [building], [budget]) VALUES ('Music', 'Packard', 80000);
INSERT INTO [guest].[department]([dept_name], [building], [budget]) VALUES ('Physice', 'Watson', 90000);



INSERT INTO [guest].[student] ( [ID], [name], [dept_name], [tot_cred] )
VALUES
	( '00128', 'Zhang', 'Comp.Sci.', 102 ),
	( '12345', 'Shangkar', 'Comp.Sci.', 32 ),
	( '19991', 'Brandt', 'History', 80 ),
	( '23121', 'Chavez', 'Finance', 110 ),
	( '44553', 'Peltier', 'Physice', 56 ),
	( '45678', 'Levy', 'Physice', 46 ),
	( '54321', 'Williams', 'Comp.Sci.', 54 ),
	( '55739', 'Sanchez', 'Music', 38 ),
	( '70557', 'Snow', 'Physice', 0 ),
	( '76543', 'Brown', 'Comp.Sci.', 58 ),
	( '76653', 'Aoi', 'Elec.Eng.', 60 ),
	( '98765', 'Bourikas', 'Elec.Eng.', 98 ),
	( '98988', 'Tanaka', 'Biology', 120 )
