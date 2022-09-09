import discord
from discord import Option
from discord.ext import commands, tasks
import mysql.connector
from config import *
import datetime

client = discord.Bot(intents=discord.Intents.all())


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
async def anuncio(ctx, acao: Option(str, "Ação", choices=["enviar", "adicionar", "remover", "cancelar", "lista"]), tipo: Option(str, "Tipo", required=False), *, mensagem: Option(str, "Mensagem", required=False)):
    if acao == "enviar":
        # TODO Enviar anuncio
        pass
    elif acao == "adicionar":
        await ctx.defer()
        mysqlconnection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="discord",
            auth_plugin='mysql_native_password'
        )
        mysqlcursor = mysqlconnection.cursor()
        mysqlcursor.execute(
            f"INSERT INTO `anunciodata` (`update`,`tipo`) VALUES ('{mensagem}', '{tipo}')")
        mysqlconnection.commit()
    elif acao == "remover":
        await ctx.defer()
        mysqlconnection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="discord",
            auth_plugin='mysql_native_password'
        )
        mysqlcursor = mysqlconnection.cursor()
        mysqlcursor.execute("SELECT * FROM `anuncios`")
        result = mysqlcursor.fetchall()
        for x in result:
            if mensagem in x[1]:
                mysqlcursor.execute(
                    f"DELETE FROM `anuncios` WHERE `mensagem` = '{x[1]}'")
                mysqlconnection.commit()
                embed = discord.Embed(title=f"{ctx.author.display_name}",
                                      description=f"```Anúncio removido com sucesso!```", color=discord.Colour.random())
                embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
                embed.set_footer(text="UltimateBot • 2022")
                embed.timestamp = datetime.datetime.now()
                await ctx.respond(embed=embed, delete_after=10)
    elif acao == "lista":
        await ctx.defer()
        mysqlconnection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="discord",
            auth_plugin='mysql_native_password'
        )
        mysqlcursor = mysqlconnection.cursor()
        mysqlcursor.execute("SELECT * FROM `anunciodata` ORDER BY tipo")
        result = mysqlcursor.fetchall()
        embed = discord.Embed(title=f"{ctx.author.display_name}",
                              description=f"```Lista de mensagens para o próximo anúncio```", color=discord.Colour.random())
        embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
        embed.set_footer(text="UltimateBot • 2022")
        embed.timestamp = datetime.datetime.now()
        for x in result:
            embed.add_field(name=f"Tipo: {x[2]}", value=f"{x[1]}", inline=False)
        await ctx.respond(embed=embed, delete_after=10)
    elif acao == "cancelar":
        await ctx.defer()
        embed = discord.Embed(title=f"{ctx.author.display_name}",
                              description=f"```Anúncio cancelado!```", color=discord.Colour.random())
        embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
        embed.set_footer(text="UltimateBot • 2022")
        embed.timestamp = datetime.datetime.now()
        await ctx.respond(embed=embed, delete_after=10)


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
        embed = discord.Embed(title=f"{ctx.author.nick}",
                              description=f"```Use: /aviso <@Membro>```", color=discord.Colour.random())
        embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
        embed.set_footer(text="UltimateBot • 2022")
        embed.timestamp = datetime.datetime.now()
        await ctx.respond(embed=embed, delete_after=5)
    else:
        embed = discord.Embed(title=f"{ctx.author.nick}",
                              description=f"```Selecione o tipo de aviso que quer dar ao membro {membro.display_name}.```", color=discord.Colour.random())
        embed.set_thumbnail(url=f"{ctx.author.avatar.url}")
        embed.set_footer(text="UltimateBot • 2022")
        embed.timestamp = datetime.datetime.now()
        await ctx.respond(embed=embed, view=AvisoCMD(membro=membro))


############# END COMMANDS #############

client.run("OTMyNTkyNjk5NjgzNTA0MTU4.GX_1mQ.cHYrqKEzs9sS4qE9GxsHevAUdIY6y1Jbo9uQeI")
