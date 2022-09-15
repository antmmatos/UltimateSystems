import discord
from discord import Option
from discord.ext import commands, tasks
import mysql.connector
from config import *
import datetime

client = discord.Bot(intents=discord.Intents.all())

organizacoes = {
    "Aztecas": 931721375306108948,
    "Cartel": 876547454663786539,
    "TheFamilies": 876547454647033952,
    "Mafia": 876547454647033950,
    "CosaNostra": 876547454647033948,
    "Vanilla": 876547454634455058,
    "EastCustoms": 876547454634455060,
    "Yakuza": 876547454634455057,
    "Bahamas": 876906196169261096,
    "Anonymous": 910905389174886440,
    "PeakyBlinders": 910906926756401172,
    "Bloods": 910909157513764915,
    "Lowriders": 910909346626543646,
    "Crips": 923695775089852446,
    "LosVagos": 954083662192869387,
    "Ballas": 966041504705572864,
    "SonsOfAnarchy": 974744945313329182,
    "MedusaBar": 983397697375576134,
    "Pearls": 992479971484377189,
    "BlackShadow": 993138356592578680,
    "ComandoVermelho": 993258163564458005,
    "Camorra": 997533723694219354,
    "MerryWeather": 998904263625420871,
    "Bratva": 1001171433982005328,
    "ShishaBarLounge": 1007702058348060753,
    "TheLostMC": 1011410200391069838,
    "ChefeAztecas": 931723128072200223,
    "ChefeCartel": 876547454663786540,
    "ChefeTheFamilies": 876547454647033953,
    "ChefeMafia": 876547454647033951,
    "ChefeCosaNostra": 876547454647033949,
    "ChefeVanilla": 876547454634455059,
    "ChefeEastCustoms": 876547454647033947,
    "ChefeYakuza": 876547454634455056,
    "ChefeBahamas": 876904539444359178,
    "ChefeAnonymous": 931375098181586995,
    "ChefePeakyBlinders": 931375361634234408,
    "ChefeBloods": 931375948404772934,
    "ChefeLowriders": 931376130898923571,
    "ChefeCrips": 931376371756843098,
    "ChefeLosVagos": 955903013661311096,
    "ChefeBallas": 955904065546641438,
    "ChefeSonsOfAnarchy": 974744105986965554,
    "ChefeMedusaBar": 983398052440211486,
    "ChefePearls": 992479552184012962,
    "ChefeBlackShadow": 993138521260965929,
    "ChefeComandoVermelho": 993571313161609229,
    "ChefeCamorra": 997534023838597293,
    "ChefeMerryWeather": 998903623637540976,
    "ChefeBratva": 1001171556812193803,
    "ChefeShishaBarLounge": 1007702349839614146,
    "ChefeTheLostMC": 1011410626742071417,
}

@client.event
async def on_ready():
    print("Ligado.")
    cooldowntask.start()
    avisotask.start()
    avisoorgtask.start()
    avisostafftask.start()
    avisofrtask.start()

############# START TASKS #############


@tasks.loop(minutes=5.0)
async def avisotask():
    mysqlconnection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="discord",
        auth_plugin='mysql_native_password'
    )
    mysqlcursor = mysqlconnection.cursor()
    mysqlcursor.execute("SELECT * FROM `avisos`")
    result = mysqlcursor.fetchall()
    for x in result:
        guild = client.get_guild(GuildID)
        username = guild.get_member(int(x[0]))
        role = discord.utils.get(guild.roles, id=Aviso1ID)
        role1 = discord.utils.get(guild.roles, id=Aviso2ID)
        role2 = discord.utils.get(guild.roles, id=Aviso3ID)
        if (int(x[5]) - 5) > 0:
            mysqlcursor.execute(
                f"UPDATE `avisos` SET `tempo` = {int(x[5]) - 5} WHERE `userid` = {x[0]}")
            mysqlconnection.commit()
        else:
            if x[4]:
                await username.remove_roles(role)
                await username.remove_roles(role1)
                await username.remove_roles(role2)
                mysqlcursor.execute(
                    f"DELETE FROM `avisos` WHERE `userid` = {x[0]}")
                mysqlconnection.commit()
            elif x[3]:
                username.remove_roles(role1)
                mysqlcursor.execute(
                    f"UPDATE `avisos` SET `tempo` = 14400, `aviso2` = 0 WHERE `userid` = {x[0]}")
                mysqlconnection.commit()
            elif x[2]:
                mysqlcursor.execute(
                    f"DELETE FROM `avisos` WHERE `userid` = {x[0]}")
                mysqlconnection.commit()
                await username.remove_roles(role)


@tasks.loop(minutes=5.0)
async def avisoorgtask():
    mysqlconnection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="discord",
        auth_plugin='mysql_native_password'
    )
    mysqlcursor = mysqlconnection.cursor()
    mysqlcursor.execute("SELECT * FROM `avisosorg`")
    result = mysqlcursor.fetchall()
    for x in result:
        guild = client.get_guild(GuildID)
        username = guild.get_member(int(x[0]))
        role = discord.utils.get(guild.roles, id=Aviso1OrgID)
        role1 = discord.utils.get(guild.roles, id=Aviso2OrgID)
        role2 = discord.utils.get(guild.roles, id=Aviso3OrgID)
        if (int(x[5]) - 5) > 0:
            mysqlcursor.execute(
                f"UPDATE `avisosorg` SET `tempo` = {int(x[5]) - 5} WHERE `userid` = {x[0]}")
            mysqlconnection.commit()
        else:
            if x[4]:
                await username.remove_roles(role)
                await username.remove_roles(role1)
                await username.remove_roles(role2)
                mysqlcursor.execute(
                    f"DELETE FROM `avisosorg` WHERE `userid` = {x[0]}")
                mysqlconnection.commit()
            elif x[3]:
                username.remove_roles(role1)
                mysqlcursor.execute(
                    f"UPDATE `avisosorg` SET `tempo` = 14400, `aviso2` = 0 WHERE `userid` = {x[0]}")
                mysqlconnection.commit()
            elif x[2]:
                mysqlcursor.execute(
                    f"DELETE FROM `avisosorg` WHERE `userid` = {x[0]}")
                mysqlconnection.commit()
                await username.remove_roles(role)


@tasks.loop(minutes=5.0)
async def avisostafftask():
    mysqlconnection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="discord",
        auth_plugin='mysql_native_password'
    )
    mysqlcursor = mysqlconnection.cursor()
    mysqlcursor.execute("SELECT * FROM `avisosstaff`")
    result = mysqlcursor.fetchall()
    for x in result:
        guild = client.get_guild(GuildID)
        username = guild.get_member(int(x[0]))
        role = discord.utils.get(guild.roles, id=Aviso1StaffID)
        role1 = discord.utils.get(guild.roles, id=Aviso2StaffID)
        role2 = discord.utils.get(guild.roles, id=Aviso3StaffID)
        if (int(x[5]) - 5) > 0:
            mysqlcursor.execute(
                f"UPDATE `avisosstaff` SET `tempo` = {int(x[5]) - 5} WHERE `userid` = {x[0]}")
            mysqlconnection.commit()
        else:
            if x[4]:
                await username.remove_roles(role)
                await username.remove_roles(role1)
                await username.remove_roles(role2)
                mysqlcursor.execute(
                    f"DELETE FROM `avisosstaff` WHERE `userid` = {x[0]}")
                mysqlconnection.commit()
            elif x[3]:
                username.remove_roles(role1)
                mysqlcursor.execute(
                    f"UPDATE `avisosstaff` SET `tempo` = 14400, `aviso2` = 0 WHERE `userid` = {x[0]}")
                mysqlconnection.commit()
            elif x[2]:
                mysqlcursor.execute(
                    f"DELETE FROM `avisosstaff` WHERE `userid` = {x[0]}")
                mysqlconnection.commit()
                await username.remove_roles(role)


@tasks.loop(minutes=5.0)
async def avisofrtask():
    mysqlconnection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="discord",
        auth_plugin='mysql_native_password'
    )
    mysqlcursor = mysqlconnection.cursor()
    mysqlcursor.execute("SELECT * FROM `avisosfaltaderespeito`")
    result = mysqlcursor.fetchall()
    for x in result:
        guild = client.get_guild(GuildID)
        username = guild.get_member(int(x[0]))
        role = discord.utils.get(guild.roles, id=Aviso1FaltaDeRespeitoID)
        role1 = discord.utils.get(guild.roles, id=Aviso2FaltaDeRespeitoID)
        role2 = discord.utils.get(guild.roles, id=Aviso3FaltaDeRespeitoID)
        if (int(x[5]) - 5) > 0:
            mysqlcursor.execute(
                f"UPDATE `avisosfaltaderespeito` SET `tempo` = {int(x[5]) - 5} WHERE `userid` = {x[0]}")
            mysqlconnection.commit()
        else:
            if x[4]:
                await username.remove_roles(role)
                await username.remove_roles(role1)
                await username.remove_roles(role2)
                mysqlcursor.execute(
                    f"DELETE FROM `avisosfaltaderespeito` WHERE `userid` = {x[0]}")
                mysqlconnection.commit()
            elif x[3]:
                username.remove_roles(role1)
                mysqlcursor.execute(
                    f"UPDATE `avisosfaltaderespeito` SET `tempo` = 14400, `aviso2` = 0 WHERE `userid` = {x[0]}")
                mysqlconnection.commit()
            elif x[2]:
                mysqlcursor.execute(
                    f"DELETE FROM `avisosfaltaderespeito` WHERE `userid` = {x[0]}")
                mysqlconnection.commit()
                await username.remove_roles(role)


@tasks.loop(minutes=5.0)
async def cooldowntask():
    mysqlconnection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="discord",
        auth_plugin='mysql_native_password'
    )
    mysqlcursor = mysqlconnection.cursor()
    mysqlcursor.execute("SELECT * FROM `cooldown`")
    result = mysqlcursor.fetchall()
    for x in result:
        if (int(x[2]) - 5) > 0:
            mysqlcursor.execute(
                f"UPDATE `cooldown` SET `cooldown` = {int(x[2]) - 5} WHERE `userid` = {x[0]}")
            mysqlconnection.commit()
        else:
            guild = client.get_guild(GuildID)
            mysqlcursor.execute(
                f"DELETE FROM `cooldown` WHERE `userid` = {x[0]}")
            mysqlconnection.commit()
            username = guild.get_member(int(x[0]))
            role = discord.utils.get(guild.roles, id=CooldownID)
            await username.remove_roles(role)

############# END TASKS #############
############# START COMMANDS #############


@client.command(description="Comando para limpar mensagens do chat.")
@commands.has_permissions(administrator=True)
async def limpar(ctx, quantidade: int = None):
    if quantidade == None:
        embed = discord.Embed(title=f"{ctx.author.display_name}",
                              description=f"```Use: /limpar <Quantidade>```", color=discord.Colour.random())
        embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
        embed.set_footer(text="UltimateBot • 2022")
        embed.timestamp = datetime.datetime.now()
        await ctx.respond(embed=embed, delete_after=5)
    else:
        await ctx.defer()
        await ctx.channel.purge(limit=quantidade)
        embed = discord.Embed(title=f"{ctx.author.display_name}",
                              description=f"```Mensagens apagadas: {quantidade}```", color=discord.Colour.random())
        embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
        embed.set_footer(text="UltimateBot • 2022")
        embed.timestamp = datetime.datetime.now()
        await ctx.respond(embed=embed, delete_after=10)


@client.command(description="Comando para enviar anúncios.")
@commands.has_permissions(administrator=True)
async def anuncio(ctx, ação: Option(str, "Ação", choices=["enviar", "adicionar", "remover", "lista"]), argumento2: Option(str, "Argumento 2", required=False), *, mensagem: Option(str, "Mensagem", required=False)):
    mysqlconnection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="discord",
            auth_plugin='mysql_native_password'
        )
    mysqlcursor = mysqlconnection.cursor()
    if ação == "enviar":
        novo = ""
        alterado = ""
        removido = ""
        corrigido = ""
        mysqlcursor.execute("SELECT * FROM `anunciodata`")
        result = mysqlcursor.fetchall()
        mysqlcursor.execute("SELECT * FROM `updatecounter`")
        uv = mysqlcursor.fetchone()
        uv = int(uv[0])
        embed = discord.Embed(title=f"UPDATE",
                                  description=f"```UV: {uv}```", color=discord.Colour.random())
        embed.set_thumbnail(url="https://i.imgur.com/JUIUqvJ.png")
        embed.set_footer(text="UltimateBot • 2022")
        embed.timestamp = datetime.datetime.now()
        for x in result:
            if x[2] == "novo":
                novo += f"<:novo:919661456830656512> {x[1]}\n"
            elif x[2] == "alterado":
                alterado += f"<:alterado:919667618120630283> {x[1]}\n"
            elif x[2] == "removido":
                removido += f"<:removido:919661469157699635> {x[1]}\n"
            elif x[2] == "corrigido":
                corrigido += f"<:bug1:919662472472973363> {x[1]}\n"
        embed.add_field(name="<:novo:919661456830656512> ```Novo```", value=f"**{novo}**\n", inline=False)
        embed.add_field(name="<:alterado:919667618120630283> ```Alterado```", value=f"**{alterado}**\n", inline=False)
        embed.add_field(name="<:removido:919661469157699635> ```Removido```", value=f"**{removido}**\n", inline=False)
        embed.add_field(name="<:bug1:919662472472973363> ```Corrigido```", value=f"**{corrigido}**\n", inline=False)
        await ctx.respond(embed=embed)
        mysqlcursor.execute(f"UPDATE `updatecounter` SET `counter` = {uv+1}")
        mysqlconnection.commit()
    elif ação == "adicionar":
        if argumento2 == None or mensagem == None or not (argumento2 in ["novo", "alterado", "removido", "corrigido"]):
            embed = discord.Embed(title=f"{ctx.author.display_name}",
                                  description=f"```Use: /anuncio adicionar <tipo> <mensagem>```", color=discord.Colour.random())
            embed.add_field(name="Tipos", value="``` - novo\n - alterado\n - removido\n - corrigido```")
            embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
            embed.set_footer(text="UltimateBot • 2022")
            embed.timestamp = datetime.datetime.now()
            await ctx.respond(embed=embed, delete_after=5)
            return
        await ctx.defer()
        mysqlcursor.execute(
            f"INSERT INTO `anunciodata` (`update`,`tipo`) VALUES ('{mensagem}', '{argumento2}')")
        mysqlconnection.commit()
        embed = discord.Embed(title=f"{ctx.author.display_name}",
                              description=f"```Mensagem {mensagem} adicionada à categoria {argumento2}```", color=discord.Colour.random())
        embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
        embed.set_footer(text="UltimateBot • 2022")
        embed.timestamp = datetime.datetime.now()
        await ctx.respond(embed=embed)
    elif ação == "remover":
        if argumento2 == None:
            embed = discord.Embed(title=f"{ctx.author.display_name}",
                                  description=f"```Use: /anuncio remover <ID>```", color=discord.Colour.random())
            embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
            embed.set_footer(text="UltimateBot • 2022")
            embed.timestamp = datetime.datetime.now()
            await ctx.respond(embed=embed, delete_after=5)
            return
        await ctx.defer()
        mysqlcursor.execute(f"SELECT * FROM `anunciodata` WHERE ID = {argumento2}")
        result = mysqlcursor.fetchone()
        if result:
            mysqlcursor.execute(f"DELETE FROM `anunciodata` WHERE ID = {argumento2}")
            mysqlconnection.commit()
            embed = discord.Embed(title=f"{ctx.author.display_name}",
                              description=f"```Mensagem com o ID {argumento2} ({result[1]}) apagada```", color=discord.Colour.random())
            embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
            embed.set_footer(text="UltimateBot • 2022")
            embed.timestamp = datetime.datetime.now()
            await ctx.respond(embed=embed)
        else:
            embed = discord.Embed(title=f"{ctx.author.display_name}",
                              description=f"```Mensagem com o ID {argumento2} não encontrada```", color=discord.Colour.random())
            embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
            embed.set_footer(text="UltimateBot • 2022")
            embed.timestamp = datetime.datetime.now()
            await ctx.respond(embed=embed, delete_after=10)
    elif ação == "lista":
        await ctx.defer()
        mysqlcursor.execute("SELECT * FROM `anunciodata` ORDER BY tipo")
        result = mysqlcursor.fetchall()
        embed = discord.Embed(title=f"{ctx.author.display_name}",
                              description=f"```Lista de mensagens para o próximo anúncio```", color=discord.Colour.random())
        embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
        embed.set_footer(text="UltimateBot • 2022")
        embed.timestamp = datetime.datetime.now()
        emoji = ""
        for x in result:
            if x[2] == "novo":
                emoji = "<:novo:919661456830656512>"
            elif x[2] == "alterado":
                emoji = "<:alterado:919667618120630283>"
            elif x[2] == "removido":
                emoji = "<:removido:919661469157699635>"
            elif x[2] == "corrigido":
                emoji = "<:bug1:919662472472973363>"
            embed.add_field(name=f"{emoji} {x[1]}", value=f"ID: {x[0]}\n", inline=False)
        else:
            embed.description = f"```Lista de mensagens para o próximo anúncio vazia```"
        await ctx.respond(embed=embed)


@client.command(description="Comando para dar cooldown a um membro. Requer permissões de administrador.")
@commands.has_permissions(manage_roles=True)
async def cooldown(ctx, membro: discord.Member = None):
    tempo = 3
    mysqlconnection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="discord",
        auth_plugin='mysql_native_password'
    )
    mysqlcursor = mysqlconnection.cursor()
    if membro == None:
        embed = discord.Embed(title=f"{ctx.author.display_name}",
                              description=f"```Use: /cooldown <@Membro>```", color=discord.Colour.random())
        embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
        embed.set_footer(text="UltimateBot • 2022")
        embed.timestamp = datetime.datetime.now()
        await ctx.respond(embed=embed, delete_after=5)
    else:
        mysqlcursor.execute(
            f"SELECT * FROM `cooldown` WHERE `userid` = {membro.id}")
        result = mysqlcursor.fetchone()
        if not result:
            mysqlcursor.execute(
                f"SELECT * FROM `cooldowntimes` WHERE `userid` = {membro.id}")
            result = mysqlcursor.fetchone()
            if not result:
                mysqlcursor.execute(
                    f"INSERT INTO `cooldowntimes` (`userid`, `username`, `times`) VALUES ({membro.id}, '{membro.display_name}', 1)")
                mysqlconnection.commit()
            else:
                mysqlcursor.execute(
                    f"UPDATE `cooldowntimes` SET `times` = {int(result[2]) + 1} WHERE `userid` = {membro.id}")
                mysqlconnection.commit()
                if int(result[2]) < 2:
                    tempo = 5
                elif int(result[2]) >= 2:
                    tempo = 7
            mysqlcursor.execute(
                f"INSERT INTO `cooldown` (`userid`, `username`, `cooldown`) VALUES ({membro.id}, '{membro.display_name}', {tempo*60*24})")
            mysqlconnection.commit()
            role = discord.utils.get(ctx.guild.roles, id=CooldownID)
            await membro.add_roles(role)
            embed = discord.Embed(title=f"{ctx.author.display_name}",
                                  description=f"```Cooldown de {tempo} dias adicionado com sucesso ao membro {membro.display_name} por {ctx.author.display_name}!```", color=discord.Colour.random())
            embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
            embed.set_footer(text="UltimateBot • 2022")
            embed.timestamp = datetime.datetime.now()
            await ctx.respond(embed=embed)
            for x in organizacoes:
                role = discord.utils.get(ctx.guild.roles, id=organizacoes[x])
                if role in membro.roles:
                    await membro.remove_roles(role)
        else:
            mysqlcursor.execute(
                f"SELECT * FROM `cooldown` WHERE `userid` = {membro.id}")
            result = mysqlcursor.fetchone()
            if result:
                role = discord.utils.get(
                    ctx.guild.roles, id=CooldownID)
                await membro.remove_roles(role)
                embed = discord.Embed(title=f"{ctx.author.display_name}",
                                      description=f"```Cooldown removido com sucesso ao membro {membro.display_name} por {ctx.author.display_name}.```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await ctx.respond(embed=embed)
                mysqlcursor.execute(
                    f"DELETE FROM `cooldown` WHERE `userid` = {membro.id}")
                mysqlconnection.commit()
                mysqlcursor.execute(
                    f"SELECT * FROM `cooldowntimes` WHERE `userid` = {membro.id}")
                result = mysqlcursor.fetchone()
                if int(result[2]) == 1:
                    mysqlcursor.execute(
                        f"DELETE FROM `cooldowntimes` WHERE `userid` = {membro.id}")
                    mysqlconnection.commit()
                else:
                    mysqlcursor.execute(
                        f"UPDATE `cooldowntimes` SET `times` = {int(result[2]) - 1} WHERE `userid` = {membro.id}")
                    mysqlconnection.commit()
            else:
                embed = discord.Embed(title=f"{ctx.author.display_name}",
                                      description=f"```O utilizador selecionado não está em cooldown.```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await ctx.respond(embed=embed, delete_after=10)


@client.command(description="Comando para verificar se um membro se encontra com cooldown.")
async def pesquisar(ctx, membro: discord.Member = None):
    mysqlconnection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="discord",
        auth_plugin='mysql_native_password'
    )
    mysqlcursor = mysqlconnection.cursor()
    if membro == None:
        embed = discord.Embed(title=f"{ctx.author.display_name}",
                              description=f"```Use: /pesquisar <@Membro>```", color=discord.Colour.random())
        embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
        embed.set_footer(text="UltimateBot • 2022")
        embed.timestamp = datetime.datetime.now()
        await ctx.respond(embed=embed, delete_after=5)
    else:
        mysqlcursor.execute(
            f"SELECT * FROM `cooldown` WHERE `userid` = {membro.id}")
        result = mysqlcursor.fetchone()
        if not result:
            embed = discord.Embed(
                title=f"{membro.display_name}", description=f"```O membro selecionado não se encontra com cooldown.```", color=discord.Colour.random())
            embed
            embed.set_thumbnail(url=f"{membro.avatar.url}")
            embed.set_footer(text="UltimateBot • 2022")
            embed.timestamp = datetime.datetime.now()
            await ctx.respond(embed=embed, delete_after=5)
        else:
            minutos = int(result[2])
            embed = discord.Embed(
                title=f"{membro.display_name}", description=f"```Cooldown: {minutos / 60} horas```", color=discord.Colour.random())
            embed.set_thumbnail(url=f"{membro.avatar.url}")
            embed.set_footer(text="UltimateBot • 2022")
            embed.timestamp = datetime.datetime.now()
            await ctx.respond(embed=embed)


class AvisoCMD(discord.ui.View):  # Create a class called MyView that subclasses discord.ui.View
    def __init__(self, membro):
        self.membro = membro
        super().__init__(timeout=None)

    @discord.ui.button(label="Aviso", style=discord.ButtonStyle.red, emoji="⚠️")
    async def avisobtn(self, button, interaction):
        if not (self.membro.id == interaction.user.id):
            return
        mysqlconnection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="discord",
            auth_plugin='mysql_native_password'
        )
        mysqlcursor = mysqlconnection.cursor()
        mysqlcursor.execute(
            f"SELECT * FROM `avisos` WHERE `userid` = {self.membro.id}")
        result = mysqlcursor.fetchone()
        if result != None:
            if result[4]:
                embed = discord.Embed(
                    title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} já atingiu o limite de avisos.```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{self.membro.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await interaction.response.send_message(embed=embed)
                return
            if result[3]:
                embed = discord.Embed(
                    title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} levou o 3º aviso. Aviso efetuado por: {interaction.user.display_name}.```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{self.membro.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await interaction.response.send_message(embed=embed)
                role = discord.utils.get(
                    interaction.guild.roles, id=Aviso3ID)
                await self.membro.add_roles(role)
                mysqlcursor.execute(
                    f"UPDATE `avisos` SET `tempo` = 7200, `aviso3` = 1 WHERE `userid` = {result[0]}")
                mysqlconnection.commit()
            else:
                embed = discord.Embed(
                    title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} levou o 2º aviso. Aviso efetuado por: {interaction.user.display_name}.```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{self.membro.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await interaction.response.send_message(embed=embed)
                role = discord.utils.get(
                    interaction.guild.roles, id=Aviso2ID)
                await self.membro.add_roles(role)
                mysqlcursor.execute(
                    f"UPDATE `avisos` SET `tempo` = 14400, `aviso2` = 1 WHERE `userid` = {result[0]}")
                mysqlconnection.commit()
        else:
            embed = discord.Embed(
                title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} levou o 1º aviso. Aviso efetuado por: {interaction.user.display_name}.```", color=discord.Colour.random())
            embed.set_thumbnail(url=f"{self.membro.avatar.url}")
            embed.set_footer(text="UltimateBot • 2022")
            embed.timestamp = datetime.datetime.now()
            await interaction.response.send_message(embed=embed)
            role = discord.utils.get(
                interaction.guild.roles, id=Aviso1ID)
            await self.membro.add_roles(role)
            mysqlcursor.execute(
                f"INSERT INTO `avisos` (`userid`, `username`, `aviso1`, `tempo`) VALUES ({self.membro.id}, '{self.membro.display_name}', 1, 14400)")
            mysqlconnection.commit()

    @discord.ui.button(label="Aviso de Organização", style=discord.ButtonStyle.blurple, emoji="⚠️")
    async def avisoorgbtn(self, button, interaction):
        if not (self.membro.id == interaction.user.id):
            return
        mysqlconnection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="discord",
            auth_plugin='mysql_native_password'
        )
        mysqlcursor = mysqlconnection.cursor()
        mysqlcursor.execute(
            f"SELECT * FROM `avisosorg` WHERE `userid` = {self.membro.id}")
        result = mysqlcursor.fetchone()
        if result != None:
            if result[4]:
                embed = discord.Embed(
                    title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} já atingiu o limite de avisos de organização.```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{self.membro.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await interaction.response.send_message(embed=embed)
                return
            if result[3]:
                embed = discord.Embed(
                    title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} levou o 3º aviso de organização. Aviso efetuado por: {interaction.user.display_name}.```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{self.membro.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await interaction.response.send_message(embed=embed)
                role = discord.utils.get(
                    interaction.guild.roles, id=Aviso3OrgID)
                await self.membro.add_roles(role)
                mysqlcursor.execute(
                    f"UPDATE `avisosorg` SET `tempo` = 7200, `aviso3` = 1 WHERE `userid` = {result[0]}")
                mysqlconnection.commit()
            else:
                embed = discord.Embed(
                    title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} levou o 2º aviso de organização. Aviso efetuado por: {interaction.user.display_name}.```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{self.membro.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await interaction.response.send_message(embed=embed)
                role = discord.utils.get(
                    interaction.guild.roles, id=Aviso2OrgID)
                await self.membro.add_roles(role)
                mysqlcursor.execute(
                    f"UPDATE `avisosorg` SET `tempo` = 14400, `aviso2` = 1 WHERE `userid` = {result[0]}")
                mysqlconnection.commit()
        else:
            embed = discord.Embed(
                title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} levou o 1º aviso de organização. Aviso efetuado por: {interaction.user.display_name}.```", color=discord.Colour.random())
            embed.set_thumbnail(url=f"{self.membro.avatar.url}")
            embed.set_footer(text="UltimateBot • 2022")
            embed.timestamp = datetime.datetime.now()
            await interaction.response.send_message(embed=embed)
            role = discord.utils.get(
                interaction.guild.roles, id=Aviso1OrgID)
            await self.membro.add_roles(role)
            mysqlcursor.execute(
                f"INSERT INTO `avisosorg` (`userid`, `username`, `aviso1`, `tempo`) VALUES ({self.membro.id}, '{self.membro.display_name}', 1, 14400)")
            mysqlconnection.commit()

    @discord.ui.button(label="Aviso Staff", style=discord.ButtonStyle.secondary, emoji="⚠️")
    async def avisostaffbtn(self, button, interaction):
        if not (self.membro.id == interaction.user.id):
            return
        mysqlconnection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="discord",
            auth_plugin='mysql_native_password'
        )
        mysqlcursor = mysqlconnection.cursor()
        mysqlcursor.execute(
            f"SELECT * FROM `avisosstaff` WHERE `userid` = {self.membro.id}")
        result = mysqlcursor.fetchone()
        if result != None:
            if result[4]:
                embed = discord.Embed(
                    title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} já atingiu o limite de avisos de staff.```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{self.membro.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await interaction.response.send_message(embed=embed)
                return
            if result[3]:
                embed = discord.Embed(
                    title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} levou o 3º aviso staff. Aviso efetuado por: {interaction.user.display_name}.```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{self.membro.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await interaction.response.send_message(embed=embed)
                role = discord.utils.get(
                    interaction.guild.roles, id=Aviso3StaffID)
                await self.membro.add_roles(role)
                mysqlcursor.execute(
                    f"UPDATE `avisosstaff` SET `tempo` = 7200, `aviso3` = 1 WHERE `userid` = {result[0]}")
                mysqlconnection.commit()
            else:
                embed = discord.Embed(
                    title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} levou o 2º aviso staff. Aviso efetuado por: {interaction.user.display_name}.```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{self.membro.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await interaction.response.send_message(embed=embed)
                role = discord.utils.get(
                    interaction.guild.roles, id=Aviso2StaffID)
                await self.membro.add_roles(role)
                mysqlcursor.execute(
                    f"UPDATE `avisosstaff` SET `tempo` = 14400, `aviso2` = 1 WHERE `userid` = {result[0]}")
                mysqlconnection.commit()
        else:
            embed = discord.Embed(
                title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} levou o 1º aviso staff. Aviso efetuado por: {interaction.user.display_name}.```", color=discord.Colour.random())
            embed.set_thumbnail(url=f"{self.membro.avatar.url}")
            embed.set_footer(text="UltimateBot • 2022")
            embed.timestamp = datetime.datetime.now()
            await interaction.response.send_message(embed=embed)
            role = discord.utils.get(
                interaction.guild.roles, id=Aviso1StaffID)
            await self.membro.add_roles(role)
            mysqlcursor.execute(
                f"INSERT INTO `avisosstaff` (`userid`, `username`, `aviso1`, `tempo`) VALUES ({self.membro.id}, '{self.membro.display_name}', 1, 14400)")
            mysqlconnection.commit()

    @discord.ui.button(label="Aviso Falta de Respeito", style=discord.ButtonStyle.success, emoji="⚠️")
    async def avisofrbtn(self, button, interaction):
        if not (self.membro.id == interaction.user.id):
            return
        mysqlconnection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="discord",
            auth_plugin='mysql_native_password'
        )
        mysqlcursor = mysqlconnection.cursor()
        mysqlcursor.execute(
            f"SELECT * FROM `avisosfaltaderespeito` WHERE `userid` = {self.membro.id}")
        result = mysqlcursor.fetchone()
        if result != None:
            if result[4]:
                embed = discord.Embed(
                    title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} já atingiu o limite de avisos de falta de respeito.```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{self.membro.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await interaction.response.send_message(embed=embed)
                return
            if result[3]:
                embed = discord.Embed(
                    title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} levou o 3º aviso. Aviso efetuado por: {interaction.user.display_name}.```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{self.membro.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await interaction.response.send_message(embed=embed)
                role = discord.utils.get(
                    interaction.guild.roles, id=Aviso3FaltaDeRespeitoID)
                await self.membro.add_roles(role)
                mysqlcursor.execute(
                    f"UPDATE `avisosfaltaderespeito` SET `tempo` = 7200, `aviso3` = 1 WHERE `userid` = {result[0]}")
                mysqlconnection.commit()
            else:
                embed = discord.Embed(
                    title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} levou o 2º aviso. Aviso efetuado por: {interaction.user.display_name}.```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{self.membro.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await interaction.response.send_message(embed=embed)
                role = discord.utils.get(
                    interaction.guild.roles, id=Aviso2FaltaDeRespeitoID)
                await self.membro.add_roles(role)
                mysqlcursor.execute(
                    f"UPDATE `avisosfaltaderespeito` SET `tempo` = 14400, `aviso2` = 1 WHERE `userid` = {result[0]}")
                mysqlconnection.commit()
        else:
            embed = discord.Embed(
                title=f"{self.membro.display_name}", description=f"```O membro {self.membro.display_name} levou o 1º aviso. Aviso efetuado por: {interaction.user.display_name}.```", color=discord.Colour.random())
            embed.set_thumbnail(url=f"{self.membro.avatar.url}")
            embed.set_footer(text="UltimateBot • 2022")
            embed.timestamp = datetime.datetime.now()
            await interaction.response.send_message(embed=embed)
            role = discord.utils.get(
                interaction.guild.roles, id=Aviso1FaltaDeRespeitoID)
            await self.membro.add_roles(role)
            mysqlcursor.execute(
                f"INSERT INTO `avisosfaltaderespeito` (`userid`, `username`, `aviso1`, `tempo`) VALUES ({self.membro.id}, '{self.membro.display_name}', 1, 14400)")
            mysqlconnection.commit()


@client.command(name="aviso", description="Comando para dar avisos a membros. Requer permissões de administrador.")
@commands.has_permissions(manage_roles=True)
async def aviso(ctx, membro: discord.Member = None):
    if membro == None:
        embed = discord.Embed(title=f"{ctx.author.display_name}",
                              description=f"```Use: /aviso <@Membro>```", color=discord.Colour.random())
        embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
        embed.set_footer(text="UltimateBot • 2022")
        embed.timestamp = datetime.datetime.now()
        await ctx.respond(embed=embed, delete_after=5)
    else:
        embed = discord.Embed(title=f"{ctx.author.display_name}",
                              description=f"```Selecione o tipo de aviso que quer dar ao membro {membro.display_name}.```", color=discord.Colour.random())
        embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
        embed.set_footer(text="UltimateBot • 2022")
        embed.timestamp = datetime.datetime.now()
        await ctx.respond(embed=embed, view=AvisoCMD(membro=membro))


############# END COMMANDS #############

client.run("OTMyNTkyNjk5NjgzNTA0MTU4.GX_1mQ.cHYrqKEzs9sS4qE9GxsHevAUdIY6y1Jbo9uQeI")
